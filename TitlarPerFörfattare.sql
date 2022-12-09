SELECT Namn = F�rnamn +' ' + Efternamn, 
	   �lder = CAST(
					 ( CAST(LEFT(CAST(GETDATE() as Date), 4) as int) - CAST( LEFT(F�delsedatum, 4) as int) )
				as nvarchar) + ' �r',
		Titlar = CAST(Titlar as nvarchar) + ' st',
		Lagerv�rde = CAST(Lagerv�rde as nvarchar) + ' kr'
FROM F�rfattare F
		Inner JOIN
(SELECT Result. F�rfattareID, Titlar = COUNT (Result.F�rfattareID) FROM (SELECT F�rnamn, F�rfattareID FROM B�cker B 
	Inner JOIN F�rfattare F ON B.F�rfattareID = F.ID) Result GROUP BY Result.F�rfattareID) Antal
	ON F.ID = Antal.F�rfattareID
	Inner JOIN
(SELECT R.F�rfattareID , Lagerv�rde = SUM(R.TotalPris) FROM 
	(SELECT F�rfattareID, TotalPris = ([Antal B�cker] * Pris) From LagerSaldo LS Inner JOIN B�cker B 
		ON LS.ISBN13 = B.ISBN13) R GROUP BY R.F�rfattareID) ResultAntal
	ON F.ID = ResultAntal.F�rfattareID



