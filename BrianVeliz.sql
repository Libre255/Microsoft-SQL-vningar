/*Moonmissions */
SELECT Spacecraft, [Launch date], [Carrier rocket], Operator, [Mission type] INTO SuccessfulMissions FROM MoonMissions WHERE Outcome = 'Successful'
GO
UPDATE SuccessfulMissions SET Operator = LTRIM(Operator)
GO

SELECT Operator, [Mission type], [Mission count] = COUNT(Operator)
FROM SuccessfulMissions GROUP BY Operator, [Mission type] HAVING COUNT(Operator) > 1 ORDER BY Operator, [Mission type]
GO

/*Users*/
SELECT ID, UserName, Password, 
	   Name = FirstName +' '+ LastName,
	   Gender = CASE WHEN (LEFT(RIGHT(ID, 2), 1) % 2) = 0 THEN 'Female' ELSE 'Male' END, 
	   Email, Phone 
INTO NewUsers 
FROM Users

GO
SELECT UserName as [User name], [Duplicate amount] = COUNT(UserName) FROM NewUsers GROUP BY UserName HAVING COUNT(UserName) > 1
GO
UPDATE Users SET UserName = STUFF(UserName, 3, 2,'') + CONVERT(nvarchar, ABS(CHECKSUM(NEWID()) % 10))
FROM Users U
	INNER JOIN
		(SELECT UserName as [User name], [Duplicate amount] = COUNT(UserName) 
		 FROM NewUsers GROUP BY UserName 
		 HAVING COUNT(UserName) > 1) NU 
ON U.UserName = NU.[User name]
GO
DELETE FROM NewUsers WHERE Gender = 'Female' AND LEFT(ID, 2) < 70
GO
INSERT INTO NewUsers VALUES ('990909-4321', 'pika', 'jwidowfw4jw3r90', 'Pikachu', 'Male', 'pikachu@hotmail.com', '072-0129355')
GO

/*Company*/
SELECT PRO.Id, ProductName, CompanyName as [Suppliers], CategoryName 
	FROM company.products PRO 
Inner JOIN company.suppliers  SUP ON PRO.SupplierId = SUP.Id 
Inner JOIN company.categories CAT ON PRO.CategoryId = CAT.Id
GO
SELECT RegionDescription, [Amount employees] FROM company.regions Regions_ INNER JOIN 
	(SELECT Testa.RegionId, [Amount employees] = COUNT(Testa.Id) FROM
		(SELECT EM.Id, RegionId FROM company.employees EM 
			Inner JOIN company.employee_territory EmTER ON EM.Id = EmTER.EmployeeId
			Inner JOIN company.territories TER ON EmTER.TerritoryId = TER.Id GROUP BY RegionId, EM.Id) Testa
	 GROUP BY Testa.RegionId) AmountEmployees ON Regions_.Id = AmountEmployees.RegionId