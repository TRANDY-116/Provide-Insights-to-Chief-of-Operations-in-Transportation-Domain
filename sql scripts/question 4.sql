/*	4.	Peak and Low Demand Months by City --
		For each city, identify the month with the highest total trips (peak demand) and the month with the lowest total trips (low demand). 
        This analysis will help Goodcabs understand seasonal patterns and adjust resources accordingly.
*/
WITH AggregatedCounts AS (
    SELECT 
        dc.city_name,
        dd.month_name,
        COUNT(ft.trip_id) AS record_count
    FROM 
        trips_db.fact_trips ft
    JOIN
        trips_db.dim_date dd
    ON
        ft._date = dd._date
    JOIN
        trips_db.dim_city dc
    ON
        ft.city_id = dc.city_id
    GROUP BY 
        dc.city_name, dd.month_name
),
RankedCounts AS (
    SELECT 
        city_name,
        month_name,
        record_count,
        ROW_NUMBER() OVER (PARTITION BY city_name ORDER BY record_count DESC) AS rank_highest,
        ROW_NUMBER() OVER (PARTITION BY city_name ORDER BY record_count ASC) AS rank_lowest
    FROM 
        AggregatedCounts
)
SELECT 
    city_name,
    month_name,
    record_count,
    CASE 
        WHEN rank_highest = 1 THEN 'Highest'
        WHEN rank_lowest = 1 THEN 'Lowest'
    END AS record_type
FROM 
    RankedCounts
WHERE 
    rank_highest = 1 OR rank_lowest = 1
ORDER BY 
    city_name, 
    record_type DESC, 
    record_count DESC;
