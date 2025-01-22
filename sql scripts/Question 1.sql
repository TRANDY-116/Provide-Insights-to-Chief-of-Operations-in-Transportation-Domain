/*	1.	Top and Bottom Performing Cities -- 
		Identify the top 3 and bottom 3 cities by total trips over the entire analysis period.
*/
-- Top 3 cities and 3 least cities in terms of trip counts
WITH trip_counts AS (
    SELECT 
        COUNT(ft.trip_id) AS trip_count,
        ft.city_id,
        dc.city_name,
        ROW_NUMBER() OVER (ORDER BY COUNT(ft.trip_id) DESC) AS rank_desc,
        ROW_NUMBER() OVER (ORDER BY COUNT(ft.trip_id) ASC) AS rank_asc
    FROM trips_db.fact_trips ft
    JOIN trips_db.dim_city dc ON ft.city_id = dc.city_id
    GROUP BY ft.city_id, dc.city_name
)
SELECT 
    city_name,
	trip_count
FROM trip_counts
WHERE rank_desc <= 3  -- Top 3 cities
   OR rank_asc <= 3    -- Least 3 cities
ORDER BY trip_count DESC;
