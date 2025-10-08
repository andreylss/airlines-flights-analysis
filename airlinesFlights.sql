
-- Creating a table to store flight information
CREATE TABLE AirlinesFlights (
    [index] INT PRIMARY KEY,         -- unique ID for each flight
    airline VARCHAR(50),             -- airline name
    flight VARCHAR(20),              -- flight code
    source_city VARCHAR(50),         -- city where the flight starts
    departure_time VARCHAR(50),      -- time of day when the flight departs (morning, evening, etc.)
    stops VARCHAR(20),               -- number of stops or description (zero, one, etc.)
    arrival_time VARCHAR(50),        -- time of day when the flight arrives
    destination_city VARCHAR(50),    -- destination city
    class VARCHAR(20),               -- flight class (economy, business, etc.)
    duration DECIMAL(4,2),           -- flight duration in hours
    days_left INT,                   -- days remaining until the flight
    price DECIMAL(10,2)              -- flight price
);



-- Loading flight data from a CSV file into the AirlinesFlights table
BULK INSERT AirlinesFlights
FROM 'C:\projetos-sql\airline-reviews\airlines_flights_data.csv'
WITH (
    FIELDTERMINATOR = ',',   -- columns in the CSV are separated by commas
    ROWTERMINATOR = '0x0a', -- each row ends with a newline character
    FIRSTROW = 2,           -- skip the first row because it has headers
    CODEPAGE = '65001',     -- file is in UTF-8 encoding
    TABLOCK                 -- lock the table for faster bulk insert
);


-- View all data in the AirlinesFlights table
SELECT *
FROM AirlinesFlights;




-- ######################
-- ## General Exploration ##
-- ######################

-- 1. How many unique flights exist for each airline?
SELECT 
    airline, 
    COUNT(DISTINCT flight) AS total_flights
FROM AirlinesFlights
GROUP BY airline;

-- 2. How many flights depart from each source city?
SELECT 
    source_city, 
    COUNT(*) AS flight_count
FROM AirlinesFlights
GROUP BY source_city;

-- 3. Which flight class is the most common?
SELECT 
    class, 
    COUNT(*) AS count
FROM AirlinesFlights
GROUP BY class
ORDER BY count DESC;

-- 4. Average flight duration per flight
SELECT 
    flight,  
    AVG(duration) AS avg_duration
FROM AirlinesFlights
GROUP BY flight;

-- 5. Flight price stats (average, min, max) per destination city
SELECT 
    destination_city,
    AVG(price) AS avg_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM AirlinesFlights
GROUP BY destination_city;

-- ######################
-- ## Time Analysis ##
-- ######################

-- 1. How many flights arrive at each time of day per destination?
SELECT 
    destination_city,
    arrival_time,
    COUNT(*) AS flight_count
FROM AirlinesFlights
GROUP BY destination_city, arrival_time
ORDER BY destination_city ASC, arrival_time ASC;

-- 2. Which arrival period has the longest flights on average?
SELECT 
    arrival_time, 
    AVG(duration) AS avg_duration
FROM AirlinesFlights
GROUP BY arrival_time
ORDER BY avg_duration DESC;

-- 3. Which arrival period has the most expensive flights on average?
SELECT 
    arrival_time,
    AVG(price) AS avg_price
FROM AirlinesFlights
GROUP BY arrival_time
ORDER BY avg_price DESC;

-- 4. How many flights have only 1 day left until departure?
SELECT 
    COUNT(*) AS flight_count
FROM AirlinesFlights
WHERE days_left = 1;

-- 5. Which airline has the most non-stop flights (stops = 'zero')?
SELECT 
    airline,
    COUNT(*) AS flight_count
FROM AirlinesFlights
WHERE stops = 'zero'
GROUP BY airline;

-- 6. Which airline has the most expensive flights on average?
SELECT
    airline,
    CAST(AVG(price) AS DECIMAL(10,2)) AS avg_price
FROM AirlinesFlights
GROUP BY airline
ORDER BY avg_price DESC;

-- 7. Which airline has the fastest flights on average?
SELECT 
    airline,
    AVG(duration) AS avg_duration
FROM AirlinesFlights
GROUP BY airline
ORDER BY avg_duration;

-- 8. Compare average flight duration by class (Economy vs Business)
SELECT 
    class,
    AVG(duration) AS avg_duration
FROM AirlinesFlights
GROUP BY class;

-- ###############################
-- ## Distribution and Frequency ##
-- ###############################

-- 1. How many flights fall into different duration ranges (<2h, 2-2.5h, >2.5h)?
WITH DurationRanges AS (
    SELECT
        CASE
            WHEN duration < 2 THEN '< 2 hours'
            WHEN duration BETWEEN 2 AND 2.5 THEN '2 - 2.5 hours'
            ELSE '> 2.5 hours'
        END AS duration_range
    FROM AirlinesFlights
)
SELECT
    duration_range,
    COUNT(*) AS flight_count
FROM DurationRanges
GROUP BY duration_range
ORDER BY
    CASE
        WHEN duration_range = '< 2 hours' THEN 1
        WHEN duration_range = '2 - 2.5 hours' THEN 2
        ELSE 3
    END;

-- 2. How many flights fall into different price ranges (<6000, 6000-6050, >6050)?
SELECT
    CASE
        WHEN price < 6000 THEN '< 6000'
        WHEN price BETWEEN 6000 AND 6050 THEN '6000 - 6050'
        ELSE '> 6050'
    END AS price_range,
    COUNT(*) AS flight_count
FROM AirlinesFlights
GROUP BY
    CASE
        WHEN price < 6000 THEN '< 6000'
        WHEN price BETWEEN 6000 AND 6050 THEN '6000 - 6050'
        ELSE '> 6050'
    END;

-- 3. Top 5 destination cities with the most flights departing from Delhi
SELECT TOP 5
    destination_city,
    COUNT(*) AS flight_count
FROM AirlinesFlights
WHERE source_city = 'Delhi'
GROUP BY destination_city
ORDER BY flight_count DESC;
