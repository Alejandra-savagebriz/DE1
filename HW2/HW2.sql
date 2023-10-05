-- First session
-- Exercises 1-6, queries and answers are in the following code

-- Creation of databases
CREATE SCHEMA firstdb;
CREATE SCHEMA FIRSTDB;
create schema firstDB;

-- Using specific database and droping it
USE firstdb;
DROP SCHEMA firstdb;
DROP SCHEMA IF EXISTS firstdb;

-- Creating birdstrikes DB
CREATE SCHEMA birdstrikes;
USE birdstrikes;
CREATE TABLE birdstrikes 
(id INTEGER NOT NULL,
aircraft VARCHAR(32),
flight_date DATE NOT NULL,
damage VARCHAR(16) NOT NULL,
airline VARCHAR(255) NOT NULL,
state VARCHAR(255),
phase_of_flight VARCHAR(32),
reported_date DATE,
bird_size VARCHAR(16),
cost INTEGER NOT NULL,
speed INTEGER,PRIMARY KEY(id));

-- First queries and variables
SELECT * FROM birdstrikes;
SHOW VARIABLES LIKE "secure_file_priv";
SHOW VARIABLES LIKE "local_infile";
SELECT cost FROM birstrikes;

-- Creating new table
CREATE TABLE new_birdstrikes LIKE birdstrikes;
SELECT * FROM new_birdstrikes; -- creates skeleton
SHOW TABLES;
DESCRIBE new_birdstrikes;
DROP TABLE IF EXISTS new_birdstrikes;
CREATE TABLE employee (
    id INT NOT NULL,
    employee_name VARCHAR(255) NOT NULL);
DROP TABLE IF EXISTS employee;


-- EXERCISE 1
CREATE TABLE employee(id INTEGER NOT NULL, employee_name VARCHAR(255) NOT NULL, PRIMARY KEY(id));
-- As a result the table was created

-- Insert data
INSERT INTO employee (id,employee_name) VALUES(1,'Student1');
INSERT INTO employee (id,employee_name) VALUES(2,'Student2');
INSERT INTO employee (id,employee_name) VALUES(3,'Student4');
SELECT * FROM employee;
INSERT INTO employee (id,employee_name) VALUES(3,'Student4'); -- error due to primary unique

-- Update tables
UPDATE employee SET employee_name='Arnold Schwarzenegger' WHERE id = '3';
DELETE FROM employee WHERE id=3;
TRUNCATE employee; -- delete all rows

-- User creation/permissions
CREATE USER 'alesavage'@'%' IDENTIFIED BY 'alesavage'; -- %means that user can access from anywhere
CREATE USER 'alesavagebriz'@'%' IDENTIFIED BY 'ale';
GRANT ALL ON birdstrikes.employee TO 'alesavagebriz'@'%';
GRANT SELECT (state) ON birdstrikes.birdstrikes TO 'alesavagebriz'@'%';

-- Alias
SELECT *,speed/2 FROM birdstrikes; -- synthetic data, in the database it does not add, just for the results
SELECT *,speed/2 AS halfspeed FROM birdstrikes; -- aliasing
SELECT * FROM birdstrikes LIMIT 10;
SELECT * FROM birdstrikes LIMIT 10,1;

-- EXERCISE 2
SELECT state FROM birdstrikes LIMIT 144,1;
-- Tennessee

SELECT state,cost FROM birdstrikes ORDER BY cost DESC;

-- EXERCISE 3
SELECT * FROM birdstrikes as b ORDER BY b.flight_date DESC;
SELECT id, flight_date FROM birdstrikes ORDER BY flight_date DESC;
-- 2000-04-18


SELECT * FROM birdstrikes WHERE state = 'Alabama';

-- EXERCISE 4
SELECT DISTINCT cost FROM birdstrikes ORDER BY cost DESC LIMIT 49,1;
SELECT DISTINCT cost FROM birdstrikes WHERE damage='caused damage' ORDER BY cost DESC LIMIT 49,1;
-- 5345 & 1336 (considering damage as 'caused damage')

-- Queries
SELECT * FROM birdstrikes WHERE state != 'Alabama';
SELECT * FROM birdstrikes WHERE state LIKE '%na'; #all states that end with na, Al% all states that start with Al
SELECT * FROM birdstrikes WHERE state NOT LIKE 'North_a%';
SELECT * FROM birdstrikes WHERE state = 'Alabama' AND bird_size = 'Small';
SELECT * FROM birdstrikes WHERE state = 'Alabama' OR state='Texas' AND bird_size = 'Small';
SELECT * FROM birdstrikes WHERE state = 'Alabama' OR state = 'Texas';
SELECT * FROM birdstrikes WHERE state IS NOT NULL AND state != ' ' ORDER BY state;
SELECT * FROM birdstrikes WHERE state IN ('Alabama','Texas', 'New York');
SELECT DISTINCT state FROM birdstrikes WHERE LENGTH(state)=5;

-- EXERCISE 5
SELECT DISTINCT state FROM birdstrikes WHERE state != '' AND state IS NOT NULL AND bird_size!='' AND bird_size IS NOT NULL LIMIT 1,1;
-- Colorado

-- Queries
SELECT * FROM birdstrikes WHERE speed = 350;
SELECT * FROM birdstrikes WHERE speed >= 10000;
SELECT ROUND(SQRT(speed/2) * 10) AS synthetic_speed FROM birdstrikes;
SELECT * FROM birdstrikes where cost BETWEEN 20 AND 40; -- 20 and 40 not included

-- Dates
SELECT * FROM birdstrikes WHERE flight_date = "2000-01-02";
SELECT * FROM birdstrikes WHERE flight_date >= '2000-01-01' AND flight_date <= '2000-01-03';
SELECT * FROM birdstrikes where flight_date BETWEEN "2000-01-01" AND "2000-01-03";

-- EXERCISE 6
SELECT DATEDIFF(NOW(), MAX(flight_date)) FROM birdstrikes WHERE WEEKOFYEAR(flight_date) = 52 AND state = 'Colorado';
-- 8677

