SELECT 
    city_name, 
    ROUND((SUM(CASE WHEN trip_count = '2-Trips' THEN repeat_passenger_count ELSE 0 END) * 100.0 / SUM(repeat_passenger_count)), 2) AS "2-Trip",
    ROUND((SUM(CASE WHEN trip_count = '3-Trips' THEN repeat_passenger_count ELSE 0 END) * 100.0 / SUM(repeat_passenger_count)), 2) AS "3-Trip",
    ROUND((SUM(CASE WHEN trip_count = '4-Trips' THEN repeat_passenger_count ELSE 0 END) * 100.0 / SUM(repeat_passenger_count)), 2) AS "4-Trip",
    ROUND((SUM(CASE WHEN trip_count = '5-Trips' THEN repeat_passenger_count ELSE 0 END) * 100.0 / SUM(repeat_passenger_count)), 2) AS "5-Trip",
    ROUND((SUM(CASE WHEN trip_count = '6-Trips' THEN repeat_passenger_count ELSE 0 END) * 100.0 / SUM(repeat_passenger_count)), 2) AS "6-Trip",
    ROUND((SUM(CASE WHEN trip_count = '7-Trips' THEN repeat_passenger_count ELSE 0 END) * 100.0 / SUM(repeat_passenger_count)), 2) AS "7-Trip",
    ROUND((SUM(CASE WHEN trip_count = '8-Trips' THEN repeat_passenger_count ELSE 0 END) * 100.0 / SUM(repeat_passenger_count)), 2) AS "8-Trip",
    ROUND((SUM(CASE WHEN trip_count = '9-Trips' THEN repeat_passenger_count ELSE 0 END) * 100.0 / SUM(repeat_passenger_count)), 2) AS "9-Trip",
    ROUND((SUM(CASE WHEN trip_count = '10-Trips' THEN repeat_passenger_count ELSE 0 END) * 100.0 / SUM(repeat_passenger_count)), 2) AS "10-Trip"
FROM 
    trips_db.dim_repeat_trip_distribution drtp
LEFT JOIN 
    trips_db.dim_city dc
    ON drtp.city_id = dc.city_id
GROUP BY 
    city_name
ORDER BY
	city_name;
