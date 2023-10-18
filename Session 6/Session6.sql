-- EXERCISE 1: Create a physical copy of birdstrikes with recirds where state is Oklahama
USE birdstrikes;
CREATE TABLE oklahoma_birdstrikes AS SELECT * FROM birdstrikes WHERE state='OKLAHOMA';
SELECT * FROM oklahoma_birdstrikes;
----------------------------------------------
USE classicmodels;
DROP PROCEDURE IF EXISTS CreateProductSalesStore;

DELIMITER //
CREATE PROCEDURE CreateProductSalesStore()
BEGIN

	DROP TABLE IF EXISTS product_sales;

	CREATE TABLE product_sales AS
	SELECT 
	   orders.orderNumber AS SalesId, 
	   orderdetails.priceEach AS Price, 
	   orderdetails.quantityOrdered AS Unit,
	   products.productName AS Product,
	   products.productLine As Brand,   
	   customers.city As City,
	   customers.country As Country,   
	   orders.orderDate AS Date,
	   WEEK(orders.orderDate) as WeekOfYear
	FROM
		orders
	INNER JOIN
		orderdetails USING (orderNumber)
	INNER JOIN
		products USING (productCode)
	INNER JOIN
		customers USING (customerNumber)
	ORDER BY 
		orderNumber, 
		orderLineNumber;

END //
DELIMITER ;
CALL CreateProductSalesStore();

-- Scheduling
-- Create messages table
CREATE TABLE IF NOT EXISTS messages (message varchar(100) NOT NULL);
TRUNCATE messages;

-- Events to schedule ETL jobs
SHOW VARIABLES LIKE "event_scheduler"; -- its on

-- EXERCISE 2: Create a scheduler which writes the current time in messages in every second
DELIMITER $$

CREATE EVENT MessageScheduler
ON SCHEDULE EVERY 1 SECOND
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR -- Runs every second for an hour
DO
	BEGIN
		INSERT INTO messages SELECT CONCAT('event:',NOW());
    		CALL messages;
	END$$
DELIMITER ;
SHOW EVENTS;
SELECT * FROM messages;


DELIMITER $$

CREATE EVENT CreateProductSalesStoreEvent
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
	BEGIN
		INSERT INTO messages SELECT CONCAT('event:',NOW());
    		CALL CreateProductSalesStore();
	END$$
DELIMITER ;
SHOW EVENTS;

-- Trigger as ETL
DELIMITER $$

CREATE TRIGGER trigger_namex
    AFTER INSERT ON table_namex FOR EACH ROW
BEGIN
    -- statements
    -- NEW.orderNumber, NEW.productCode etc
END$$    
DELIMITER ;

-- The trigger
USE classicmodels;
DROP TRIGGER IF EXISTS after_order_insert; 

DELIMITER $$

CREATE TRIGGER after_order_insert
AFTER INSERT
ON orderdetails FOR EACH ROW
BEGIN
	
	-- log the order number of the newley inserted order
    	INSERT INTO messages SELECT CONCAT('new orderNumber: ', NEW.orderNumber);

	-- archive the order and assosiated table entries to product_sales
  	INSERT INTO product_sales
	SELECT 
	   orders.orderNumber AS SalesId, 
	   orderdetails.priceEach AS Price, 
	   orderdetails.quantityOrdered AS Unit,
	   products.productName AS Product,
	   products.productLine As Brand,
	   customers.city As City,
	   customers.country As Country,   
	   orders.orderDate AS Date,
	   WEEK(orders.orderDate) as WeekOfYear
	FROM
		orders
	INNER JOIN
		orderdetails USING (orderNumber)
	INNER JOIN
		products USING (productCode)
	INNER JOIN
		customers USING (customerNumber)
	WHERE orderNumber = NEW.orderNumber
	ORDER BY 
		orderNumber, 
		orderLineNumber;
        
END $$

DELIMITER ;

-- Activating the trigger: Listing the current state of the product_sales. Please note that, there is no orderNumber 16.
SELECT * FROM product_sales ORDER BY SalesId;
INSERT INTO orders  VALUES(16,'2020-10-01','2020-10-01','2020-10-01','Done','',131);
INSERT INTO orderdetails  VALUES(16,'S18_1749','1','10',1);
SELECT * FROM product_sales ORDER BY SalesId;

-- Data marts with Views
DROP VIEW IF EXISTS Vintage_Cars;
CREATE VIEW `Vintage_Cars` AS
SELECT * FROM product_sales WHERE product_sales.Brand = 'Vintage Cars';

DROP VIEW IF EXISTS USA;
CREATE VIEW `USA` AS
SELECT * FROM product_sales WHERE country = 'USA';
SELECT * FROM classicmodels.Vintage_Cars;

-- EXERCISE 4: Create a view, which contains product_sales rows of 2003 and 2005.
DROP VIEW IF EXISTS Sales_0305;
CREATE VIEW `Sales_0305` AS
SELECT * FROM product_sales WHERE YEAR(Date) IN (2003,2005);
SELECT * FROM classicmodels.Sales_0305;
-- Views are not physical copies, materialize view are not supported in sql
-- In the internet check how to create materialized views

-- TERM PROJECT
-- Use dataset
-- Join tables for analysis
-- Merge it, check dimensions of study
-- Create etl pipeline, trigger or events
-- create questions and create a view
-- create views
-- create data marts 
-- create visualizations
-- delivery of code, how is it documented, self explanatory, documentation
-- for testing use inserts and various selects, special tests
-- er diagram
-- copy scheme
-- create model and put it in the documentation
-- creation should be part of the model also
-- model file also in the project
-- automated script
-- from model create table in sql like in customers in classicmodels
-- use and create drops if something fail and want to run somthing again
-- tienes el modelo, schema transform, file export, forward engineering sql create sql