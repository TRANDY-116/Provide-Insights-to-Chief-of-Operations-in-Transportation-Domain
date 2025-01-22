/*	8.	Highest and Lowest Repeat Passenger Rate (RPR%) by City and Month --
		I.	Analyse the Repeat Passenger Rate (RPR%) for each city across the six-month period. 
			Identify the top 2 and bottom 2 cities based on their RPR% to determine which locations have the strongest and weakest rates.
		II.	Similarly, analyse the RPR% by month across all cities and identify the months with the highest and lowest repeat passenger rates. 
			This will help to pin-point any seasonal patterns or months with higher repeat passenger loyalty.
*/
WITH avg_RPR_by_city AS (
		SELECT
			dc.city_name,
			ROUND(AVG(repeat_passengers * 100.0/ total_passengers), 2 ) AS rpr_percent
		FROM
			trips_db.fact_passenger_summary fps
		JOIN
			trips_db.dim_city dc
		ON
			fps.city_id = dc.city_id
		GROUP BY
			dc.city_name
		ORDER BY
			rpr_percent DESC
)
-- Top and Bottom 2 Cities by RPR%: 
(
SELECT * 
FROM avg_rpr_by_city
ORDER BY rpr_percent DESC
LIMIT 2
)
UNION ALL
(
SELECT * 
FROM avg_rpr_by_city
ORDER BY rpr_percent ASC
LIMIT 2
); 


WITH avg_rpr_by_month AS (
		SELECT
			dd.month_name,
			ROUND(AVG(repeat_passengers * 100.0/ total_passengers), 2 ) AS rpr_percent
		FROM
			trips_db.fact_passenger_summary fps
		JOIN
			trips_db.dim_date dd
		ON
			fps._month = dd.start_of_month
		GROUP BY
			dd.month_name
		ORDER BY
			rpr_percent DESC
)
-- Months with Highest and Lowest RPR%:
(
SELECT *
FROM avg_rpr_by_month
ORDER BY rpr_percent DESC
LIMIT 1
)
UNION ALL
(
SELECT *
FROM avg_rpr_by_month
ORDER BY rpr_percent ASC
LIMIT 1
);