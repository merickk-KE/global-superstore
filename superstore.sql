-- creating database
CREATE SCHEMA superstore;

-- creating table for orders
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
Row_ID INT,
Order_ID VARCHAR(50),
Order_date VARCHAR(20),
Ship_date VARCHAR(20),
Ship_mode VARCHAR(50),
Customer_ID VARCHAR(50),
Customer_name VARCHAR(100),
Segment VARCHAR(100),
City VARCHAR(50),
State VARCHAR(50),
Country VARCHAR(50),
Region VARCHAR(50),
Market VARCHAR(50),
Product_ID VARCHAR(50),
Product_name VARCHAR(255),
Sub_category VARCHAR(100),
Category VARCHAR(100),
Sales DECIMAL(10,2),
Quantity INT,
Discount DECIMAL(10,2),
Profit DECIMAL(10,2),
Shipping_cost DECIMAL(10,2),
Order_priority VARCHAR(20),
Shipping_duration INT,
Price_per_item DECIMAL(10,2)
);

-- creating table for people details 
DROP TABLE IF EXISTS people;
CREATE TABLE people (
Person VARCHAR(255),
Region VARCHAR(100)
);

-- creating table for returns 
DROP TABLE IF EXISTS returns;
CREATE TABLE returns (
Returned VARCHAR(10),
Order_ID VARCHAR(100),
Region VARCHAR(100)
);

-- importing table data 
SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/Global superstore/Global Superstore Data.csv' INTO TABLE orders
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- count of the number of rows in the table
SELECT COUNT(*) FROM orders;

SELECT COUNT(*) FROM returns;

SELECT COUNT(*) FROM people;

-- table descriptions
DESCRIBE orders;
DESCRIBE people;
DESCRIBE returns;

-- changing datatypes
ALTER TABLE orders
MODIFY COLUMN Order_date DATE;
ALTER TABLE orders
MODIFY COLUMN Ship_date DATE;

-- Total sales, profit & quantity
SELECT 
    SUM(Sales) AS Total_sales,
    SUM(Profit) AS Total_profit,
    SUM(Quantity) AS Total_quantity
FROM orders;

-- Top 10 cities by sales
SELECT City, SUM(Sales) AS Sales
FROM orders
GROUP BY City
ORDER BY Sales DESC
LIMIT 10;

-- Profit by category
SELECT Category, SUM(Profit) AS Profit
FROM orders
GROUP BY Category
ORDER BY Profit DESC;

-- Shipping Delay Analysis
SELECT 
    Ship_Mode,
    AVG(DATEDIFF(Ship_Date, Order_Date)) AS Avg_Shipping_Days
FROM orders
GROUP BY Ship_Mode;

-- 10 Best selling products 
SELECT Product_name, SUM(Sales) AS Revenue
FROM orders
GROUP BY Product_name
ORDER BY Revenue DESC
LIMIT 10;

-- Best selling products per region
SELECT Product_name, Region,
COUNT(Product_name) AS Total_products_sold 
FROM orders
GROUP BY Product_name, Region
ORDER BY Total_products_sold DESC
LIMIT 10;

-- Sales by category 
SELECT Category,
COUNT(Product_ID) AS Count_products
FROM orders
GROUP BY Category
ORDER BY Count_products DESC;

-- Profit by region
SELECT Region, SUM(Profit) AS regional_profit
FROM orders
GROUP BY Region
ORDER BY regional_profit DESC;

-- Monthly sales trends
SELECT DATE_FORMAT(Order_date, '%Y-%m') AS month,
	SUM(Sales) AS monthly_sales
FROM orders
GROUP BY month
ORDER BY month ASC;

-- Returned products 
SELECT o.Order_ID, r.Region, o.Product_name
FROM orders o
JOIN returns r
ON o.Order_ID = r.Order_ID;

-- top 10 People orders per region ordered by revenue
SELECT o.Region, p.Person, SUM(o.Sales) AS Revenue
FROM orders o
LEFT JOIN people p
ON o.Region = p.Region
GROUP BY o.Region, p.Person
LIMIT 10;
