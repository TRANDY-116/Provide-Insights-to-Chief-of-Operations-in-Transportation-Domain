-- Average ratings by city and passenger type
SELECT 
	dc.city_name,
	ROUND(AVG(driver_rating), 2) AS avg_driver_rating,
	ROUND(AVG(passenger_rating), 2) AS avg_passenger_rating,
	passenger_type
FROM 
	trips_db.fact_trips ft
JOIN 
	trips_db.dim_city dc
ON 
	ft.city_id = dc.city_id
GROUP BY 
	dc.city_name,
	ft.passenger_type
	
ORDER BY 
	passenger_type DESC,
	avg_driver_rating desc,
	avg_passenger_rating DESC