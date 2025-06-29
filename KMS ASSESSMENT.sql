CREATE DATABASE KMS


CREATE TABLE KMS (
    Row_ID INT PRIMARY KEY,
    Order_ID INT,
    Order_Date DATE,
    Order_Priority VARCHAR(10),
    Order_Quantity INT,
    Sales DECIMAL(10,2),
    Discount DECIMAL(4,2),
    Ship_Mode VARCHAR(50),
    Profit DECIMAL(10,2),
    Unit_Price DECIMAL(10,2),
    Shipping_Cost DECIMAL(10,2),
    Customer_Name VARCHAR(100),
    Province VARCHAR(50),
    Region VARCHAR(50),
    Customer_Segment VARCHAR(50),
    Product_Category VARCHAR(50),
    Product_Sub_Category VARCHAR(100),
    Product_Name VARCHAR(100),
    Product_Container VARCHAR(50),
    Product_Base_Margin DECIMAL(4,2),
    Ship_Date DATE
);

SELECT * FROM KMS

--1. Which product category had the highest sales? --
SELECT TOP 1 
	Product_Category, 
	ROUND(SUM(Sales),0) AS Total_Sales
FROM KMS
GROUP BY Product_Category
ORDER BY Total_Sales DESC;

--2. What are the Top 3 and Bottom 3 regions in terms of sales?---
SELECT TOP 3 
	Region, 
	ROUND(SUM(Sales),0) AS Total_Sales
FROM KMS
GROUP BY Region
ORDER BY Total_Sales DESC;

--BOTTOM 3--
SELECT TOP 3 
	Region, 
	ROUND(SUM(Sales),0) AS Total_Sales
FROM KMS
GROUP BY Region
ORDER BY Total_Sales ASC;


--3. What were the total sales of appliances in Ontario?--
SELECT 
	ROUND(SUM(Sales),0) AS Total_Appliance_Sales
FROM KMS
WHERE [Product_Sub-Category] LIKE '%Appliance%' AND Province = 'Ontario';


--4. Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers --
SELECT TOP 10 
	Customer_Name, 
	ROUND(SUM(Sales),0) AS Total_Sales
FROM KMS
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;

-- 5. KMS incurred the most shipping cost using which shipping method?---
SELECT TOP 1 
	Ship_Mode, 
	ROUND(SUM(Shipping_Cost),0) AS Total_Shipping_Cost
FROM KMS
GROUP BY Ship_Mode
ORDER BY Total_Shipping_Cost DESC;

--6. Who are the most valuable customers, and what products or services do they typically purchase?---
SELECT TOP 5 
	Customer_Name, 
	ROUND(SUM(Sales),0) AS Total_Sales, 
	STRING_AGG(Product_Name, ', ') AS Products
FROM KMS
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;

--7. Which small business customer had the highest sales?---
SELECT TOP 1 
	Customer_Name, 
	ROUND(SUM(Sales), 0) AS Total_Sales
FROM KMS
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;

--8, Which Corporate Customer placed the most number of orders in 2009 – 2012?---
SELECT TOP 1 
	Customer_Name, 
	COUNT(Order_ID) AS Order_Count
FROM KMS
WHERE Customer_Segment = 'Corporate'
AND YEAR(Order_Date) BETWEEN 2009 AND 2012
GROUP BY Customer_Name
ORDER BY Order_Count DESC;

--9.Which consumer customer was the most profitable one?
SELECT TOP 1 
	Customer_Name, 
	ROUND(SUM(Profit),0) AS Total_Profit
FROM KMS
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name
ORDER BY Total_Profit DESC;

--10.Which customer returned items, and what segment do they belong to?--
SELECT DISTINCT k.Customer_Name, k.Customer_Segment
FROM KMS k
JOIN Order_Status o ON k.Row_ID = o.Order_ID;

/*11.  If the delivery truck is the most economical but the slowest shipping method and 
--Express Air is the fastest but the most expensive one, do you think the company 
appropriately spent shipping costs based on the Order Priority? Explain your answer*/ 

SELECT 
	Order_Priority, 
	Ship_Mode, 
	ROUND(AVG(Shipping_Cost),0) AS Avg_Shipping_Cost
FROM KMS
GROUP BY Order_Priority, Ship_Mode
ORDER BY Order_Priority, Avg_Shipping_Cost DESC;