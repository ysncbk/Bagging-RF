# Bagging-RF
2018 Bremen Big Data Challenge Predictions
### Even this simple code provided about 92% of accuracy. The error rate was about 8%.###

Herzlich Willkommen zur Bremen Big Data Challenge 2018!

In der Bremen Big Data Challenge 2018 geht es darum, die produzierte Windenergie eines Onshore-Windparks vorherzusagen. Zum Training eines Vorhersagemodells erhaltet ihr von Januar 2016 bis Juni 2017 erfasste Wind-Messungen in 15-Minuten-Abschnitten und die in diesen Abschnitten vom Windpark erzeugte Windenergie ("Trainingsdaten"). Für die zweite Jahrehälfte 2017 ("Testdaten") erhaltet ihr nur die Wind-Messungen und müsst die Windenergie vorhersagen.

Alle Informationen zur BBDC 2018, zur Aufgabe und zum Abgabesystem findet ihr unter https://bbdc.csl.uni-bremen.de.

Viel Erfolg!

Alle Daten liegen als CSV-Dateien (comma separated values) vor. Die ersten drei Zeilen der Trainingsdaten (train.csv) sehen wie folgt aus:

Datum,Windgeschwindigkeit48M,Windgeschwindigkeit100M,Windgeschwindigkeit152M,Windrichtung48M,Windrichtung100M,Windrichtung152M,Windgeschwindigkeit100MP10,Windgeschwindigkeit100MP20,Windgeschwindigkeit100MP30,Windgeschwindigkeit100MP40,Windgeschwindigkeit100MP50,Windgeschwindigkeit100MP60,Windgeschwindigkeit100MP70,Windgeschwindigkeit100MP80,Windgeschwindigkeit100MP90,Interpoliert,Verfügbare_Kapazität,Output 2016-01-01 00:00:00,8.49,10.77,12.69,188.0,190.0,194.0,9.07,9.63,10.06,10.43,10.78,11.05,11.54,11.94,12.42,0,122400.0,79168 2016-01-01 00:15:00,8.395,10.6175,12.475,190.75,193.0,196.75,9.0425,9.555,9.955,10.309999999999999,10.629999999999999,10.927500000000002,11.3875,11.815,12.3125,1,122400.0,75124 2016-01-01 00:30:00,8.3,10.465,12.26,193.5,196.0,199.5,9.015,9.48,9.850000000000001,10.19,10.48,10.805,11.235,11.69,12.205,1,122400.0,76072

Dabei haben die Spalten die folgenden Bedeutungen:

    Datum: Anfangszeitpunkt eines 15-Minuten-Abschnitts (YYYY-MM-DD hh:mm:ss) in lokaler Zeit ME(S)Z.
    Windgeschwindigkeit48M, Windgeschwindigkeit100M, Windgeschwindigkeit152M: Die Windgeschwindigkeit in Höhe von 48m, 100m und 152m (gemessen in m/s).
    Windrichtung48M, Windrichtung100M, Windrichtung152M: Die Windrichtung in Höhe von 48m, 100m und 152m (gemessen in Grad).
    Windgeschwindigkeit100MP10 - Windgeschwindigkeit100MP90: Probabilistische Windgeschwindigkeiten in 100m Höhe (Percentile 10-90) in dem 15-Minuten-Abschnitt (gemessen in m/s).
    Interpoliert: Die Windmessungen liegen jeweils nur für die vollen Stunden vor und wurden daher für die 15-Minuten-Abschnitte interpoliert (siehe unten). Dieses Feld kennzeichnet solche interpolierten Werte.
    Verfügbare_Kapazität: Die zum aktuellen Zeitpunkt maximal mögliche Leistung des Windparks, gemessen in kW. Diese schwankt bspw. aufgrund von Wartungsarbeiten oder Ausfällen.
    Output: Die produzierte Windenergie (gemessen in kWh/h).

Die Testdaten (challenge.csv) haben folgendes Format: Datum,Windgeschwindigkeit48M,Windgeschwindigkeit100M,Windgeschwindigkeit152M,Windrichtung48M,Windrichtung100M,Windrichtung152M,Windgeschwindigkeit100MP10,Windgeschwindigkeit100MP20,Windgeschwindigkeit100MP30,Windgeschwindigkeit100MP40,Windgeschwindigkeit100MP50,Windgeschwindigkeit100MP60,Windgeschwindigkeit100MP70,Windgeschwindigkeit100MP80,Windgeschwindigkeit100MP90,Interpoliert,Verfügbare_Kapazität,Output 2017-07-01 00:00:00,4.85,5.81,6.41,263.0,266.0,268.0,3.92,4.75,5.16,5.53,5.82,6.04,6.3,6.85,7.46,0,119000.0,X 2017-07-01 00:15:00,4.925,5.885,6.5,262.75,265.5,267.5,3.9625,4.8175,5.2725,5.609999999999999,5.8950000000000005,6.1425,6.414999999999999,6.927499999999999,7.535,1,119000.0,X 2017-07-01 00:30:00,5.0,5.96,6.59,262.5,265.0,267.0,4.005,4.885,5.385,5.6899999999999995,5.970000000000001,6.245,6.529999999999999,7.005,7.609999999999999,1,119000.0,X

Dabei haben die Spalten dieselbe Bedeutung wie in train.csv. Die Spalte "Output" enthält konstant den Buchstaben X, um anzuzeigen, dass dieser Wert nicht vorliegt. Wenn ihr Lösungen einreicht, dann soll eure Abgabe genau den Testdaten entsprechen, wobei jedes X durch eine Zahl (nicht notwendigerweise ganzzahlig) ersetzt wurde. Diese Zahl entspricht eurer Schätzung der produzierten Windenergie für den dazugehörigen Zeitabschnitt.

Jede Abgabe wird mittels eines Fehlerscores bewertet, um das Ranking der Teilnehmer zu ermitteln. Dabei gilt: Je niedriger der Fehlerscore, desto besser der Rang der Einreichung. Der Fehlerscore wird als Cumulative Absolute Percentage Error (CAPE) zwischen der vorhergesagten Windenergie und der tatsächlich produzierten Windenergie berechnet:

CAPE = \frac{ \sum_{t=1}^T{|Predicted_t - Actual_t|} } { \sum_{T=1}^T { Basis } }

Die Basis ist konstant und entspricht der installierten Kapazität - bei dem vorliegendem Windpark sind das 122400kW. Um ein Gefühl für die Größe des Parks zu bekommen: Eine Stunde Voll-Last bei maximaler Kapazität ist ausreichend, um einen 2-Personen Haushalt für 45 Jahre mit Strom zu versorgen.

In dem Windpark wird der Wind stündlich zur vollen Stunde gemessen, die produzierte Windenergie wird jedoch viertelstündlich erhoben. Da die Windenergie auch viertelstündlich prädiziert werden soll, müssen also zwischen zwei Windmessungen jeweils drei Werte aufgefüllt werden. In train.csv und challenge.csv wurden die Windmessungen linear interpoliert und die entsprechenden Zeilen mit einer "1" in der Spalte "Interpoliert" markiert. Diese Interpolation ist nicht notwendigerweise ideal - auch hier kann gegebenenfalls eine Verbesserung erzielt werden.
