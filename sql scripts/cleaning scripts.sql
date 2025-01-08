-- Alter dim_date table
ALTER TABLE trips_db.dim_date
ALTER COLUMN _date TYPE date USING _date::DATE,
ALTER COLUMN _date SET NOT NULL,
ALTER COLUMN start_of_month TYPE DATE USING start_of_month::DATE,
ALTER COLUMN start_of_month SET NOT NULL,
ALTER COLUMN month_name TYPE VARCHAR(20),
ALTER COLUMN month_name SET NOT NULL,
ALTER COLUMN day_type TYPE VARCHAR(10),
ADD CONSTRAINT day_type_check CHECK (day_type IN ('Weekday', 'Weekend'));

-- Alter dim_city table
ALTER TABLE trips_db.dim_city
ALTER COLUMN city_id TYPE VARCHAR(10),
ALTER COLUMN city_id SET NOT NULL,
ALTER COLUMN city_name TYPE VARCHAR(255),
ALTER COLUMN city_name SET NOT NULL;

-- ALTER fact_passenger_summary table
ALTER TABLE trips_db.fact_passenger_summary
ALTER COLUMN _month TYPE DATE USING _month::DATE,
ALTER COLUMN _month SET NOT NULL,
ALTER COLUMN city_id TYPE VARCHAR(10),
ALTER COLUMN city_id SET NOT NULL,
ALTER COLUMN total_passengers TYPE INT,
ALTER COLUMN total_passengers SET NOT NULL,
ALTER COLUMN new_passengers TYPE INT,
ALTER COLUMN new_passengers SET NOT NULL,
ALTER COLUMN repeat_passengers TYPE INT,
ALTER COLUMN repeat_passengers SET NOT NULL;

-- Alter dim_repeat_trip_distribution
ALTER TABLE trips_db.dim_repeat_trip_distribution
ALTER COLUMN _month TYPE DATE USING _month::DATE,
ALTER COLUMN _month SET NOT NULL,
ALTER COLUMN city_id TYPE VARCHAR(10),
ALTER COLUMN city_id SET NOT NULL,
ALTER COLUMN trip_count TYPE VARCHAR(10),
ADD CONSTRAINT trip_count_check CHECK (trip_count IN ('1-Trip', '2-Trips', '3-Trips', '4-Trips', '5-Trips', '6-Trips', '7-Trips', '8-Trips', '9-Trips', '10-Trips')),
ALTER COLUMN repeat_passenger_count TYPE INT,
ALTER COLUMN repeat_passenger_count SET NOT NULL;

-- Alter fact_trips table
ALTER TABLE trips_db.fact_trips
-- Change column types with casting
ALTER COLUMN trip_id TYPE VARCHAR(255),
ALTER COLUMN trip_id SET NOT NULL,
ALTER COLUMN _date TYPE DATE USING _date::DATE,
ALTER COLUMN _date SET NOT NULL,
ALTER COLUMN city_id TYPE VARCHAR(10),
ALTER COLUMN city_id SET NOT NULL,
ALTER COLUMN passenger_type TYPE VARCHAR(10),
ADD CONSTRAINT passenger_type_check CHECK (passenger_type IN ('new', 'repeated'));

-- Rename column
ALTER TABLE trips_db.fact_trips
RENAME COLUMN distance_travelled_km_ TO distance_travelled_km;

-- Modify renamed column type and constraints
ALTER TABLE trips_db.fact_trips
ALTER COLUMN distance_travelled_km TYPE FLOAT,
ALTER COLUMN distance_travelled_km SET NOT NULL;

-- Update fare_amount data type for precision
ALTER TABLE trips_db.fact_trips
ALTER COLUMN fare_amount TYPE NUMERIC(10, 2),
ALTER COLUMN fare_amount SET NOT NULL;

-- Add constraints for passenger and driver ratings
ALTER TABLE trips_db.fact_trips
ALTER COLUMN passenger_rating TYPE SMALLINT,
ADD CONSTRAINT passenger_rating_check CHECK (passenger_rating BETWEEN 1 AND 10),
ALTER COLUMN driver_rating TYPE SMALLINT,
ADD CONSTRAINT driver_rating_check CHECK (driver_rating BETWEEN 1 AND 10);

-- ALTER city_target_passenger_rating
ALTER TABLE targets_db.city_target_passenger_rating
ALTER COLUMN city_id TYPE VARCHAR(10),
ALTER COLUMN city_id SET NOT NULL,
ALTER COLUMN target_avg_passenger_rating TYPE FLOAT,
ALTER COLUMN target_avg_passenger_rating SET NOT NULL;

--ALTER monthly_target_new_passengers table
ALTER TABLE targets_db.monthly_target_new_passengers
ALTER COLUMN _month TYPE DATE USING _month::DATE,
ALTER COLUMN _month SET NOT NULL,
ALTER COLUMN city_id TYPE VARCHAR(10),
ALTER COLUMN city_id SET NOT NULL,
ALTER COLUMN target_new_passengers TYPE INT,
ALTER COLUMN target_new_passengers SET NOT NULL;

-- ALTER monthly_target_trips table
ALTER TABLE targets_db.monthly_target_trips
ALTER COLUMN _month TYPE DATE USING _month::DATE,
ALTER COLUMN _month SET NOT NULL,
ALTER COLUMN city_id TYPE VARCHAR(10),
ALTER COLUMN city_id SET NOT NULL,
ALTER COLUMN total_target_trips TYPE INT,
ALTER COLUMN total_target_trips SET NOT NULL;