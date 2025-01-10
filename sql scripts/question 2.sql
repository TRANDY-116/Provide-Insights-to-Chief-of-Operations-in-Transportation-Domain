-- Average Fare per Trip by City
SELECT 
	dim_city.city_name,
	ROUND(CAST(AVG(fare_amount) AS NUMERIC), 2) AS avg_fare_by_city,
	ROUND(CAST(AVG(distance_travelled_km) AS NUMERIC), 2) AS avg_distance_by_city
FROM 
	trips_db.fact_trips
JOIN trips_db.dim_city ON fact_trips.city_id = dim_city.city_id
GROUP BY fact_trips.city_id,dim_city.city_name
ORDER BY avg_fare_by_city DESC;