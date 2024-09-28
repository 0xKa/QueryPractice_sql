USE VehicleMakesDB;

--VehicleMakesDB Tables
SELECT * FROM VehicleDetails;
SELECT * FROM SubModels;
SELECT * FROM MakeModels;
SELECT * FROM Makes;
SELECT * FROM Bodies;
SELECT * FROM DriveTypes;
SELECT * FROM FuelTypes;

--VehicleMakesDB Views
SELECT * FROM VehicleMasterDetails
SELECT * FROM NissanPathfinder
SELECT * FROM v3

--To Fix Digrams Error, run this query
USE VehicleMakesDB
GO
ALTER AUTHORIZATION ON DATABASE::VehicleMakesDB TO [sa]
GO

--P1
CREATE VIEW VehicleMasterDetails
AS
SELECT VehicleDetails.ID, VehicleDetails.MakeID, Makes.Make, VehicleDetails.ModelID, MakeModels.ModelName, VehicleDetails.SubModelID, SubModels.SubModelName, VehicleDetails.BodyID, Bodies.BodyName, VehicleDetails.Vehicle_Display_Name, VehicleDetails.Year, VehicleDetails.DriveTypeID, DriveTypes.DriveTypeName, VehicleDetails.Engine, VehicleDetails.Engine_CC, VehicleDetails.Engine_Cylinders, VehicleDetails.Engine_Liter_Display, VehicleDetails.FuelTypeID, FuelTypes.FuelTypeName, VehicleDetails.NumDoors
FROM VehicleDetails
JOIN Makes on Makes.MakeID = VehicleDetails.MakeID
JOIN MakeModels on MakeModels.ModelID = VehicleDetails.ModelID
JOIN SubModels on SubModels.SubModelID = VehicleDetails.SubModelID
JOIN Bodies on Bodies.BodyID = VehicleDetails.BodyID
JOIN DriveTypes on DriveTypes.DriveTypeID = VehicleDetails.DriveTypeID
JOIN FuelTypes on FuelTypes.FuelTypeID = VehicleDetails.FuelTypeID


--P2
SELECT * FROM VehicleDetails
WHERE Year BETWEEN 1950 AND 2000;

--P3
SELECT COUNT(*) AS NumberOfVehicles_1950_to_2000 FROM VehicleDetails
WHERE Year BETWEEN 1950 AND 2000;

--P4
SELECT Makes.Make, COUNT(*) AS NumberOfVehicles_1950_to_2000 
FROM VehicleDetails JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE (VehicleDetails.Year BETWEEN 1950 AND 2000)
GROUP BY Makes.Make
ORDER BY COUNT(*) DESC;

--P5
SELECT Makes.Make, COUNT(*) AS NumberOfVehicles_1950_to_2000 
FROM VehicleDetails JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE (VehicleDetails.Year BETWEEN 1950 AND 2000)
GROUP BY Makes.Make
HAVING COUNT(*) >= 12000
ORDER BY COUNT(*) DESC;

--without HAVING
SELECT * FROM 
(
	SELECT Makes.Make, COUNT(*) AS NumberOfVehicles_1950_to_2000 
	FROM VehicleDetails JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
	WHERE (VehicleDetails.Year BETWEEN 1950 AND 2000)
	GROUP BY Makes.Make
) r1
WHERE r1.NumberOfVehicles_1950_to_2000 >= 12000
ORDER BY r1.NumberOfVehicles_1950_to_2000 DESC

--P6
SELECT Makes.Make, COUNT(*) AS NumberOfVehicles_1950_to_2000, (SELECT COUNT(*) FROM VehicleDetails) AS TotalVehicles
FROM VehicleDetails JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE (VehicleDetails.Year BETWEEN 1950 AND 2000)
GROUP BY Makes.Make
ORDER BY COUNT(*) DESC

--P7
SELECT *, 'Percentage' = CAST(r1.NumberOfVehicles_1950_to_2000 as float) / CAST(r1.TotalVehicles as float) 
FROM 
(
SELECT Makes.Make, COUNT(*) AS NumberOfVehicles_1950_to_2000, (SELECT COUNT(*) FROM VehicleDetails) AS TotalVehicles
FROM VehicleDetails JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE (VehicleDetails.Year BETWEEN 1950 AND 2000)
GROUP BY Makes.Make
) r1
ORDER BY r1.NumberOfVehicles_1950_to_2000 DESC


--P8
SELECT Makes.Make, FuelTypes.FuelTypeName, COUNT(*) AS NumberOfVehicles
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
JOIN FuelTypes ON FuelTypes.FuelTypeID = VehicleDetails.FuelTypeID
WHERE (VehicleDetails.Year BETWEEN 1950 AND 2000)
GROUP BY FuelTypes.FuelTypeName, Makes.Make
ORDER BY Makes.Make

	--P9
SELECT VehicleDetails.*, FuelTypes.FuelTypeName
FROM VehicleDetails 
JOIN FuelTypes ON FuelTypes.FuelTypeID = VehicleDetails.FuelTypeID
WHERE FuelTypes.FuelTypeName = N'GAS'

--P10
SELECT DISTINCT Makes.Make, FuelTypeName
FROM VehicleDetails
JOIN FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE FuelTypes.FuelTypeName = N'GAS'

--using GROUP BY
SELECT Makes.Make, FuelTypeName
FROM VehicleDetails
JOIN FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE FuelTypes.FuelTypeName = N'GAS'
GROUP BY Makes.Make, FuelTypes.FuelTypeName
ORDER BY Makes.Make


--P11
SELECT 'TotalMakesThatRunGAS'= COUNT(*) FROM
(
SELECT DISTINCT Makes.Make, FuelTypeName
FROM VehicleDetails
JOIN FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE FuelTypes.FuelTypeName = N'GAS'
) r1


--P12
SELECT Makes.Make, COUNT(*) AS NumberOfVehicles
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
GROUP BY Makes.Make
ORDER BY COUNT(*) DESC

--P13
SELECT Makes.Make, COUNT(*) AS NumberOfVehicles
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
GROUP BY Makes.Make
HAVING COUNT(*) >= 20000
ORDER BY COUNT(*) DESC


--P14
SELECT * FROM Makes
WHERE Make LIKE N'B%';

--P15
SELECT * FROM Makes
WHERE Make LIKE N'%W';

--P16
SELECT DISTINCT Makes.Make, DriveTypes.DriveTypeName
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
JOIN DriveTypes ON DriveTypes.DriveTypeID = VehicleDetails.DriveTypeID
WHERE DriveTypeName = 'FWD'
ORDER BY Makes.Make

--P17
SELECT 'TOTAL' = COUNT(*) FROM 
(
SELECT DISTINCT Makes.Make, DriveTypes.DriveTypeName
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
JOIN DriveTypes ON DriveTypes.DriveTypeID = VehicleDetails.DriveTypeID
WHERE DriveTypeName = 'FWD'
) r1 


--P18
SELECT Makes.Make, DriveTypes.DriveTypeName, TotalVehicles = COUNT(*) 
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
JOIN DriveTypes ON DriveTypes.DriveTypeID = VehicleDetails.DriveTypeID
GROUP BY DriveTypes.DriveTypeName, Makes.Make
ORDER BY Makes.Make ASC, TotalVehicles DESC


--P19
SELECT Makes.Make, DriveTypes.DriveTypeName, TotalVehicles = COUNT(*) 
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
JOIN DriveTypes ON DriveTypes.DriveTypeID = VehicleDetails.DriveTypeID
GROUP BY DriveTypes.DriveTypeName, Makes.Make
HAVING COUNT(*) >= 10000
ORDER BY Makes.Make ASC, TotalVehicles DESC

--P20
SELECT * FROM VehicleDetails
WHERE NumDoors is NULL

--P21
SELECT COUNT(*) AS TOTAL 
FROM VehicleDetails 
WHERE NumDoors is NULL

--using Subquery
SELECT COUNT(*) TOTAL FROM
(
SELECT * FROM VehicleDetails
WHERE NumDoors is NULL
) r1


--P22
SELECT 
CAST(
	CAST((SELECT COUNT(*) FROM VehicleDetails WHERE NumDoors is NULL) as float) 
	/ 
	CAST((SELECT COUNT(*) FROM VehicleDetails) as float)
	* 100
as varchar)  + '%'
AS 'Percentage Of Null Vehicles'



--P23
SELECT DISTINCT MAKES.MakeID, Makes.Make, SubModels.SubModelName
FROM VehicleDetails
INNER JOIN Makes on Makes.MakeID = VehicleDetails.MakeID
INNER JOIN SubModels on SubModels.SubModelID = VehicleDetails.SubModelID
WHERE SubModels.SubModelName = 'Elite'


--P24
SELECT * FROM VehicleDetails
WHERE Engine_Liter_Display > 3 AND NumDoors = 2;

--P25
SELECT Makes.Make, VehicleDetails.* 
FROM VehicleDetails JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE Engine LIKE '%OHV%' AND Engine_Cylinders = 4

--P26
SELECT Bodies.BodyName, VehicleDetails.* FROM VehicleDetails
INNER JOIN Bodies ON Bodies.BodyID = VehicleDetails.BodyID
WHERE YEAR > 2020 AND BodyName ='Sport Utility';

--P27
SELECT Bodies.BodyName, VehicleDetails.* FROM VehicleDetails
INNER JOIN Bodies ON Bodies.BodyID = VehicleDetails.BodyID
WHERE BodyName IN ('Coupe', 'Hatchback', 'Sedan');

--P28
SELECT Bodies.BodyName, VehicleDetails.* FROM VehicleDetails
INNER JOIN Bodies ON Bodies.BodyID = VehicleDetails.BodyID
WHERE BodyName IN ('Coupe', 'Hatchback', 'Sedan') AND Year IN (2008, 2020, 2021);

--P29
SELECT Found = 1
WHERE EXISTS (SELECT TOP 1 * FROM VehicleDetails WHERE Year = 1950)

--P30
SELECT Vehicle_Display_Name, NumDoors, NumberOfDoors =
CASE 
	WHEN NumDoors = 0 THEN 'No Doors'
	WHEN NumDoors = 1 THEN 'One Door'
	WHEN NumDoors = 2 THEN 'Two Doors'
	WHEN NumDoors = 3 THEN 'Three Doors'
	WHEN NumDoors = 4 THEN 'Four Doors'
	WHEN NumDoors = 5 THEN 'Five Doors'
	WHEN NumDoors = 6 THEN 'Six Doors'
	WHEN NumDoors = 8 THEN 'Eight Doors'
	WHEN NumDoors is NULL THEN 'Not Set'
	ELSE 'Unknown'
END
FROM VehicleDetails


--P31
SELECT Vehicle_Display_Name, Year, VehicleAge = YEAR( GETDATE()) - Year
FROM VehicleDetails
ORDER BY VehicleAge DESC


--P32
SELECT * FROM 
(
SELECT Vehicle_Display_Name, Year, VehicleAge = YEAR(GETDATE()) - Year
FROM VehicleDetails
) r1
WHERE r1.VehicleAge BETWEEN 15 AND 25
ORDER BY VehicleAge ASC

--P33
SELECT 
	MIN(Engine_CC) AS 'Minimum Engine CC', 
	MAX(Engine_CC) AS 'Maximum Engine CC', 
	AVG(Engine_CC) AS 'Arvrage Engine CC'
FROM VehicleDetails

--P34
SELECT * FROM VehicleDetails
WHERE Engine_CC = (SELECT MIN(Engine_CC) FROM VehicleDetails);


--P35
SELECT * FROM VehicleDetails
WHERE Engine_CC = (SELECT MAX(Engine_CC) FROM VehicleDetails);

--P36
SELECT * FROM VehicleDetails
WHERE Engine_CC < (SELECT AVG(Engine_CC) FROM VehicleDetails);

--P37
SELECT COUNT(*) AS 'Total vehicles that have Engin_CC above average' FROM VehicleDetails
WHERE Engine_CC > (SELECT AVG(Engine_CC) FROM VehicleDetails)

--Using subquery
SELECT COUNT(*) AS 'Total vehicles that have Engin_CC above average' FROM
(
	SELECT * FROM VehicleDetails
	WHERE Engine_CC > (SELECT AVG(Engine_CC) FROM VehicleDetails)
) r1;


--P38
--Distinct Enginge CC
SELECT DISTINCT Engine_CC
FROM VehicleDetails
ORDER BY Engine_CC DESC

--Unique Enginge CC
SELECT Engine_CC
FROM VehicleDetails
GROUP BY Engine_CC 
HAVING COUNT(*) = 1 --EngineCC that appears one time is unique  
ORDER BY Engine_CC DESC


--P39
SELECT DISTINCT TOP 3 Engine_CC FROM VehicleDetails
ORDER BY Engine_CC DESC;

--P40
SELECT Vehicle_Display_Name, Engine, Engine_CC FROM VehicleDetails
WHERE Engine_CC IN (SELECT DISTINCT TOP 3 Engine_CC FROM VehicleDetails ORDER BY Engine_CC DESC)
ORDER BY Engine_CC DESC


--P41
SELECT DISTINCT Makes.Make
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE Engine_CC IN (SELECT DISTINCT TOP 3 Engine_CC FROM VehicleDetails ORDER BY Engine_CC DESC)
ORDER BY Makes.Make ASC


--P42
SELECT DISTINCT Engine_CC, 
Tax = 										 
CASE										 
	WHEN Engine_CC <= 1000 THEN 100			 	  -- 0 to 1000    Tax = 100
	WHEN Engine_CC <= 2000 THEN 200			 	  -- 1001 to 2000 Tax = 200
	WHEN Engine_CC <= 4000 THEN 300			 	  -- 2001 to 4000 Tax = 300
	WHEN Engine_CC <= 6000 THEN 400			 	  -- 4001 to 6000 Tax = 400
	WHEN Engine_CC <= 8000 THEN 500			 	  -- 6001 to 8000 Tax = 500
	WHEN Engine_CC >  8000 THEN 600				  -- Above 8000   Tax = 600
	ELSE 0										  -- Otherwise    Tax = 0
END
FROM VehicleDetails
ORDER BY Engine_CC
	
--P43
SELECT Makes.Make, SUM(NumDoors) AS TotalNumberOfDoors
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
GROUP BY Make
ORDER BY TotalNumberOfDoors DESC


--P44
SELECT Makes.Make, SUM(NumDoors) AS TotalNumberOfDoors
FROM VehicleDetails
JOIN Makes ON Makes.MakeID = VehicleDetails.MakeID
WHERE Makes.Make = 'FORD'
GROUP BY Make
ORDER BY TotalNumberOfDoors DESC


--P45
SELECT Make, COUNT(*) AS NumberOfModels
FROM Makes
JOIN MakeModels ON MakeModels.MakeID = Makes.MakeID
GROUP BY Make
ORDER BY NumberOfModels DESC

--P46
SELECT TOP 3 Make, COUNT(*) AS NumberOfModels
FROM Makes
JOIN MakeModels ON MakeModels.MakeID = Makes.MakeID
GROUP BY Make
ORDER BY NumberOfModels DESC

--P47
SELECT TOP 1 Make, COUNT(*) AS NumberOfModels
FROM Makes
JOIN MakeModels ON MakeModels.MakeID = Makes.MakeID
GROUP BY Make
ORDER BY NumberOfModels DESC

--Using Subquery
SELECT MAX(r1.NumberOfModels) AS MaximumNumberOfModels FROM 
(
SELECT Make, COUNT(*) AS NumberOfModels
FROM Makes
JOIN MakeModels ON MakeModels.MakeID = Makes.MakeID
GROUP BY Make
) r1


--P48
-- remember that they could be more than one manufacturer have the same high number of models
SELECT Make, COUNT(*) AS NumberOfModels
FROM Makes
JOIN MakeModels ON MakeModels.MakeID = Makes.MakeID
GROUP BY Make
HAVING COUNT(*) = 
			(SELECT MAX(r1.NumberOfModels) AS MaximumNumberOfModels FROM 
				(
				SELECT Make, COUNT(*) AS NumberOfModels
				FROM Makes
				JOIN MakeModels ON MakeModels.MakeID = Makes.MakeID
				GROUP BY Make
				) r1
			)

--P49
SELECT Make, COUNT(*) AS NumberOfModels
FROM Makes
JOIN MakeModels ON MakeModels.MakeID = Makes.MakeID
GROUP BY Make
HAVING COUNT(*) = 
			(SELECT MIN(r1.NumberOfModels) AS MaximumNumberOfModels FROM 
				(
				SELECT Make, COUNT(*) AS NumberOfModels
				FROM Makes
				JOIN MakeModels ON MakeModels.MakeID = Makes.MakeID
				GROUP BY Make
				) r1
			)

--P50
-- Note that the NewID() function will generate GUID for each row 
SELECT * FROM FuelTypes
ORDER BY NEWID()

--###########--

--in the next problems we will use EmployeesDB (it contains 1 table)
USE EmployeesDB
SELECT * FROM Employees

--P51: Get all employees that have manager along with Manager's name.
-- this will select all data from employees that are managed by someone along with their manager name, 
-- employees that have no manager will not be selected because we used inner join 
-- Note we used inner join on the same table with diffrent alliace.
SELECT  Employees.EmployeeID, Employees.Name, Employees.Salary, Employees.ManagerID, ManagerName = Managers.Name
FROM Employees
JOIN Employees AS Managers ON Employees.ManagerID = Managers.EmployeeID

--P52
-- this will select all data from employees regardless if they have manager or not, note here we used left outer join 
SELECT Employees.Name, Employees.ManagerID, Employees.Salary, Managers.Name AS ManagerName
FROM Employees
LEFT JOIN Employees AS Managers ON Employees.ManagerID = Managers.EmployeeID

--another solution using subquery
Select * , ManagerName = (select name from Employees As T2 Where T1.ManagerID = T2.EmployeeID) 
  from Employees As T1


--P53
SELECT Employees.Name, Employees.ManagerID, Employees.Salary,
ManagerName = 
	CASE
		WHEN Managers.Name is NULL THEN Employees.Name
		ELSE Managers.Name
	END
FROM Employees
LEFT JOIN Employees AS Managers ON Employees.ManagerID = Managers.EmployeeID

--using subquery
SELECT r1.Name, r1.ManagerID, r1.Salary, 
ManagerName = 
	CASE
		WHEN ManagerName is NULL THEN Name
		ELSE ManagerName
	END
FROM (
SELECT Employees.Name, Employees.ManagerID, Employees.Salary, Managers.Name AS ManagerName
FROM Employees
LEFT JOIN Employees AS Managers ON Employees.ManagerID = Managers.EmployeeID
) r1


--P54
SELECT Employees.Name, Employees.ManagerID, Employees.Salary, Managers.Name AS ManagerName
FROM Employees
LEFT JOIN Employees AS Managers ON Employees.ManagerID = Managers.EmployeeID
WHERE Managers.Name = 'Mohammed'






