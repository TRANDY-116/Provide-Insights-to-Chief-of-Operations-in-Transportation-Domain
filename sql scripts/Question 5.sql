/*	5.	Weekend vs. Weekday Trip Demand by City --
		Compare the total trips taken on weekdays versus weekends for each city over the six-month period. 
        Identify cities with a strong preference for either weekend or weekday trips to understand demand variations.
*/
SELECT
    dc.city_name,
    COUNT(CASE WHEN dm.day_type = 'Weekday' THEN 1 ELSE NULL END) AS weekday_trips,
    COUNT(CASE WHEN dm.day_type = 'Weekend' THEN 1 ELSE NULL END) AS weekend_trips,
	CASE
        WHEN COUNT(CASE WHEN dm.day_type = 'Weekday' THEN 1 ELSE NULL END) > COUNT(CASE WHEN dm.day_type = 'Weekend' THEN 1 ELSE NULL END) THEN 'Weekdays'
        WHEN COUNT(CASE WHEN dm.day_type = 'Weekend' THEN 1 ELSE NULL END) > COUNT(CASE WHEN dm.day_type = 'Weekday' THEN 1 ELSE NULL END) THEN 'Weekends'
        ELSE 'Equal'
    END AS higher_trip_type
FROM 
    trips_db.fact_trips ft
JOIN
    trips_db.dim_date dm
ON
    ft._date = dm._date
JOIN
    trips_db.dim_city dc
ON
    ft.city_id = dc.city_id
GROUP BY
    dc.city_name
ORDER BY
    city_name;
