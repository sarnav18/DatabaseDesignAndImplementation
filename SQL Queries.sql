-- Create Database clientData
CREATE DATABASE clientData;
-- Use Database
USE clientData;
-- Check the number of rows in database to check if all records
-- have been imported from .csv files
SELECT COUNT(1) FROM client;
SELECT COUNT(1) FROM employees;
SELECT COUNT(1) FROM itemcakes;
SELECT COUNT(1) FROM itempancakes;
SELECT COUNT(1) FROM items;
SELECT COUNT(1) FROM order_employee;
SELECT COUNT(1) FROM order_item;
SELECT COUNT(1) FROM orders;
SELECT COUNT(1) FROM shipment;
SELECT COUNT(1) FROM sysco;
SELECT * FROM sysco;

-- Assign Primary Keys to all tables
ALTER TABLE client
ADD PRIMARY KEY (PropertyID);

ALTER TABLE employees
ADD PRIMARY KEY (EmployeeID);

ALTER TABLE itemcakes 
ADD PRIMARY KEY (ItemID);

ALTER TABLE itempancakes
ADD PRIMARY KEY (ItemID);

ALTER TABLE items
ADD PRIMARY KEY (ItemID);

ALTER TABLE order_employee
ADD PRIMARY KEY (EmployeeID, OrderID);

ALTER TABLE order_item
ADD PRIMARY KEY (ItemID, OrderID);

ALTER TABLE orders
ADD PRIMARY KEY (OrderID);

ALTER TABLE shipment
ADD PRIMARY KEY (ShipmentID);

ALTER TABLE sysco
ADD PRIMARY KEY (GeoLocationID);

ALTER TABLE Employees
DROP COLUMN EmployeePhone;

ALTER TABLE employee_phone
CHANGE EmployeePhone EmployeePhone varchar (70);

ALTER TABLE employee_phone
ADD PRIMARY KEY (EmployeeID,EmployeePhone);

ALTER TABLE employees_dependent
ADD PRIMARY KEY (EmployeeID,DependentID);


-- Queries for Insights --

--  Which clients' orders were cancelled the most?
SELECT PropertyName, COUNT(1) AS Cancelled_Count
FROM Client C
LEFT JOIN orders O ON O.PropertyID = C.PropertyID
WHERE OrderStatus = 'Cancelled'
GROUP BY PropertyName
HAVING COUNT(1) = (SELECT COUNT(1) AS Cancelled_Count
FROM Client C
LEFT JOIN orders O ON O.PropertyID = C.PropertyID
WHERE OrderStatus = 'Cancelled' GROUP BY C.PropertyName ORDER BY COUNT(1) DESC LIMIT 1)
ORDER BY COUNT(1) DESC;

-- Which and how many items were ordered by the clients belonging to the parent Organization 'Frontier Management'?
SELECT DISTINCT ItemDescription, SUM(Quantity) AS TotalQuantity
FROM items I
LEFT JOIN order_item OI ON I.ItemID = OI.ItemID
LEFT JOIN orders O ON O.OrderID = OI.OrderID
LEFT JOIN client C ON C.PropertyID = O.PropertyID
WHERE `Parent Organization` = 'Frontier Management'
GROUP BY ItemDescription
ORDER BY TotalQuantity DESC;

-- Which item is the most popular?
SELECT COUNT(1), I.ItemID, I.ItemDescription
FROM order_item OI
LEFT JOIN items I ON I.ItemID = OI.ItemID
GROUP BY I.ItemID
ORDER BY COUNT(1) DESC LIMIT 1;

-- Which employees made the most orders?
-- Rename the column as CSAT_Rating (could be awarded employee of the month)?
SELECT COUNT(1) AS CSAT_Rating, EmployeeID
FROM order_employee
GROUP BY EmployeeID
HAVING COUNT(1) = 
(SELECT COUNT(1) FROM order_employee 
GROUP BY EmployeeID ORDER BY COUNT(1) DESC LIMIT 1)
ORDER BY COUNT(1) DESC;



-- In which month the sales were highest and lowest - what factors contributed to low sales?
SELECT MONTH(OrderDate) AS MonthName, COUNT(1) AS MaxSaleCount 
FROM orders
GROUP BY MONTH(OrderDate)
ORDER BY MaxSaleCount DESC LIMIT 1;

SELECT MONTH(OrderDate) AS MonthName, COUNT(1) AS MinSaleCount 
FROM orders
GROUP BY MONTH(OrderDate)
ORDER BY MinSaleCount ASC LIMIT 1;
-- List the distinct States in which the corresponding Parent Organizations fall under
SELECT DISTINCT State, `Parent Organization`
FROM sysco S
LEFT JOIN client C ON C.GeoLocationID = S.GeoLocationID
WHERE `Parent Organization` IS NOT NULL
GROUP BY  `Parent Organization`;

-- How many order were made from Texas Clients?
SELECT COUNT(DISTINCT OI.OrderID) AS OrderCount, State
FROM order_item OI 
INNER JOIN orders O ON O.OrderID= OI.OrderID
INNER JOIN client C ON C.PropertyID = O.PropertyID
INNER JOIN sysco S ON S.GeoLocationID = C.GeoLocationID
AND State = 'Texas'
GROUP BY State;

-- Which Cakes were least preferred by Clients from Florida in their order of preference
SELECT COUNT(1) AS CakeOrder, ItemDescription
FROM order_item OI 
LEFT JOIN orders O ON O.OrderID= OI.OrderID
LEFT JOIN items I ON I.ItemID = OI.ItemID
LEFT JOIN client C ON C.PropertyID = O.PropertyID
LEFT JOIN sysco S ON S.GeoLocationID = C.GeoLocationID
WHERE OI.ItemID IN (SELECT ItemID FROM itemcakes)
AND State = 'Florida'
GROUP BY ItemDescription
ORDER BY CakeOrder;

-- Which pancake is the most sold to the clients?
SELECT COUNT(1) AS PancakeOrder, ItemDescription
FROM order_item OI 
LEFT JOIN orders O ON O.OrderID= OI.OrderID
LEFT JOIN items I ON I.ItemID = OI.ItemID
LEFT JOIN client C ON C.PropertyID = O.PropertyID
LEFT JOIN sysco S ON S.GeoLocationID = C.GeoLocationID
WHERE OI.ItemID IN (SELECT ItemID FROM itempancakes)
GROUP BY ItemDescription
ORDER BY PancakeOrder DESC LIMIT 1;

-- Which Shipment Type is most preferred for Orders?
SELECT COUNT(1) AS OrderCount , ShipmentType
FROM orders O 
LEFT JOIN shipment S ON O.ShipmentID = S.ShipmentID
GROUP BY ShipmentType
ORDER BY COUNT(1) DESC;

-- What is the avergae number of days between Order Received and Shipment
SELECT AVG(DATEDIFF(DATE_FORMAT(`Shipment Date`, '%d-%m-%y'),
DATE_FORMAT(OrderDate, '%d-%m-%y'))) AS `Average Days` FROM Orders
WHERE OrderStatus IN ('Shipped','Received') ;


