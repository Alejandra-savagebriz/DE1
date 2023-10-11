-- EXERCISES 1-6

USE birdstrikes;

-- Conditional logic
SELECT aircraft, airline, cost, 
    CASE 
        WHEN cost  = 0
            THEN 'NO COST'
        WHEN  cost >0 AND cost < 100000
            THEN 'MEDIUM COST'
        ELSE 
            'HIGH COST'
    END
    AS cost_category   
FROM  birdstrikes
ORDER BY cost_category;

-- EXERCISE 1: Do the same with speed. If speed is NULL or speed < 100 create a “LOW SPEED” category, otherwise, mark as “HIGH SPEED”. Use IF instead of CASE!--
-- Using CASE
SELECT speed,
    CASE
        WHEN speed IS NULL OR speed < 100 THEN 'LOW SPEED'
        ELSE 'HIGH SPEED'
    END AS cost_category
FROM birdstrikes
ORDER BY cost_category;

-- Using IF
SELECT aicraft,airline,speed,
	IF (speed <100 OR speed IS NULL, 'LOW SPEED','HIGH SPEED') AS speed_category
	FROM  birdstrikes
	ORDER BY speed_category;

-- COUNT
-- COUNT (*)
SELECT COUNT(*) FROM birdstrikes; -- returns number of records/rows in database, do not count nulls

-- COUNT(column)
SELECT COUNT(reported_date) FROM birdstrikes; -- counts the number of not NULL records for the given column

-- DISTINCT
SELECT DISTINCT state FROM birdstrikes;
-- Count number of distinct states
SELECT COUNT(DISTINCT state) FROM birdstrikes;

-- EXERCISE 2: How many distinct ‘aircraft’ we have in the database? --
SELECT COUNT(DISTINCT aircraft) FROM birdstrikes;
-- ANSWER: 3 --

-- The sum of all repair costs of birdstrikes accidents
SELECT SUM(cost) FROM birdstrikes; -- 13010244

-- Speed in this database is measured in KNOTS. Let’s transform to KMH. 1 KNOT = 1.852 KMH
SELECT (AVG(speed)*1.852) as avg_kmh FROM birdstrikes; -- 1532.8321684

-- How many observation days we have in birdstrikes
SELECT DATEDIFF(MAX(reported_date),MIN(reported_date)) from birdstrikes; -- 1143

-- EXERCISE 3: What was the lowest speed of aircrafts starting with ‘H’ --
SELECT MIN(speed) FROM birdstrikes WHERE aircraft LIKE 'H%';
-- ANSWER: 9 --

-- GROUP BY
-- What is the highest speed by aircraft type?
SELECT MIN(speed), aircraft FROM birdstrikes GROUP BY aircraft;
SELECT state, aircraft FROM birdstrikes GR WHERE state != "" GROUP BY state,aircraft ORDER BY state;

-- Which state for which aircraft type paid the most repair cost?
SELECT state, aircraft, SUM(cost)
AS sum FROM birdstrikes WHERE state !='' 
GROUP BY state, aircraft 
ORDER BY sum DESC;

-- EXERCISE 4: Which phase_of_flight has the least of incidents? --
SELECT phase_of_flight, count(phase_of_flight) AS x FROM birdstrikes WHERE damage='No damage' group by phase_of_flight ORDER BY x LIMIT 1;
-- Answer: Taxi

-- EXERCISE 5: What is the rounded highest average cost by phase_of_flight? --
SELECT phase_of_flight, ROUND(AVG(cost)) AS x FROM birdstrikes group by phase_of_flight ORDER BY x DESC LIMIT 1;
-- Answer: 54,673

-- HAVING
-- We would like to filter the result of the aggregation. In this case we want only the results where the avg speed is equal to 50.
SELECT AVG(speed) AS avg_speed,state FROM birdstrikes GROUP BY state WHERE ROUND(avg_speed) = 50;-- Error: we need to use having
SELECT AVG(speed) AS avg_speed,state FROM birdstrikes GROUP BY state HAVING ROUND(avg_speed) = 50;

-- EXERCISE 6: What the highest AVG speed of the states with names less than 5 characters? --
SELECT AVG(speed) AS avg_speed, state FROM birdstrikes GROUP BY state HAVING length(state)<5 ORDER BY avg_speed DESC LIMIT 1;
-- Answer: 2862.5000