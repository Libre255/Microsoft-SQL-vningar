SELECT Namn = Förnamn +' ' + Efternamn, 
	   Ålder = CAST(
					 ( CAST(LEFT(CAST(GETDATE() as Date), 4) as int) - CAST( LEFT(Födelsedatum, 4) as int) )
				as nvarchar) + ' år',
		Titlar = CAST(Titlar as nvarchar) + ' st',
		Lagervärde = CAST(Lagervärde as nvarchar) + ' kr'
FROM Författare F
		Inner JOIN
(SELECT Result. FörfattareID, Titlar = COUNT (Result.FörfattareID) FROM (SELECT Förnamn, FörfattareID FROM Böcker B 
	Inner JOIN Författare F ON B.FörfattareID = F.ID) Result GROUP BY Result.FörfattareID) Antal
	ON F.ID = Antal.FörfattareID
	Inner JOIN
(SELECT R.FörfattareID , Lagervärde = SUM(R.TotalPris) FROM 
	(SELECT FörfattareID, TotalPris = ([Antal Böcker] * Pris) From LagerSaldo LS Inner JOIN Böcker B 
		ON LS.ISBN13 = B.ISBN13) R GROUP BY R.FörfattareID) ResultAntal
	ON F.ID = ResultAntal.FörfattareID



