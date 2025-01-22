/*	7.	Monthly Target Achievement Analysis for Key Metrics --
		For each city, evaluate monthly performance against targets for total trips, new passengers, and average passenger ratings 
        from targets db. Determine if each metric met, exceeded, or missed the target, and calculate the percentage difference. 
        Identify any consistent patterns in target achievement, particularly across tourism versus business-focused cities.
*/
WITH new_passengers AS (
    SELECT 
        city_id,
        _month,
        new_passengers
    FROM 
        trips_db.fact_passenger_summary
    ORDER BY
        city_id,
        _month
), 
actual_trips AS (
    SELECT
        ft.city_id,
        DATE_TRUNC('month', ft._date) AS MONTHS,
        COUNT(ft.trip_id) AS trip_number,
        AVG(ft.passenger_rating) AS avg_passenger_rating,
        np.new_passengers
    FROM 
        trips_db.fact_trips ft
    JOIN 
        new_passengers np
        ON ft.city_id = np.city_id 
        AND DATE_TRUNC('month', ft._date) = np._month
    GROUP BY
        ft.city_id,
        MONTHS,
        np.new_passengers
    ORDER BY
        ft.city_id,
        MONTHS
), 
targeted_trips AS (
    SELECT
        mtt.city_id,
        DATE_TRUNC('month', mtt._month) AS MONTHS,
        mtt.total_target_trips,
        mtnp.target_new_passengers
    FROM
        targets_db.monthly_target_trips mtt
    JOIN
        targets_db.monthly_target_new_passengers mtnp
        ON mtt.city_id = mtnp.city_id
        AND mtt._month = mtnp._month
    GROUP BY
        mtt.city_id,
        MONTHS,
        mtt.total_target_trips,
        mtnp.target_new_passengers
    ORDER BY
        city_id,
        MONTHS        
), 
targeted_avg_passenger_rating AS (
    SELECT 
        cpr.city_id,
        DATE_TRUNC('month', months._month) AS MONTHS,
        cpr.target_avg_passenger_rating
    FROM 
        targets_db.city_target_passenger_rating cpr
    JOIN 
        (
            SELECT 
                DISTINCT city_id, 
                _month 
            FROM 
                targets_db.monthly_target_trips
        ) months
    ON 
        cpr.city_id = months.city_id
    ORDER BY 
        cpr.city_id, months._month
),
targeted_trips_m AS (
    SELECT
        tt.city_id,
        tt.MONTHS,
        tt.total_target_trips,
        tt.target_new_passengers,
        ta.target_avg_passenger_rating
    FROM
        targeted_trips tt
    JOIN
        targeted_avg_passenger_rating ta
    ON
        tt.city_id = ta.city_id
    AND
        tt.MONTHS = ta.MONTHS
),
differences AS (
    SELECT
        at.city_id,
        at.MONTHS,
        at.trip_number AS total_actual_trips,
        tt.total_target_trips,
        ROUND((at.trip_number::numeric - tt.total_target_trips::numeric) / tt.total_target_trips * 100::numeric, 2) AS trip_percentage_diff,
        CASE
            WHEN at.trip_number = tt.total_target_trips THEN 'Met'
            WHEN at.trip_number > tt.total_target_trips THEN 'Exceeded'
            ELSE 'Missed'
        END AS trip_target_status,
        at.avg_passenger_rating,
        tt.target_avg_passenger_rating,
        ROUND(((at.avg_passenger_rating::numeric - tt.target_avg_passenger_rating::numeric) / tt.target_avg_passenger_rating::numeric) * 100, 2) AS rating_percentage_diff,
        CASE
            WHEN at.avg_passenger_rating = tt.target_avg_passenger_rating THEN 'Met'
            WHEN at.avg_passenger_rating > tt.target_avg_passenger_rating THEN 'Exceeded'
            ELSE 'Missed'
        END AS rating_target_status,
        at.new_passengers,
        tt.target_new_passengers,
        ROUND((at.new_passengers::numeric - tt.target_new_passengers::numeric) / tt.target_new_passengers::numeric * 100, 2) AS passenger_percentage_diff,
        CASE
            WHEN at.new_passengers = tt.target_new_passengers THEN 'Met'
            WHEN at.new_passengers > tt.target_new_passengers THEN 'Exceeded'
            ELSE 'Missed'
        END AS passenger_target_status
    FROM
        actual_trips at
    JOIN
        targeted_trips_m tt
    ON
        at.city_id = tt.city_id
        AND at.MONTHS = tt.MONTHS
)

SELECT 	
	dc.city_name,
	d.months,
	d.total_actual_trips,
	d.total_target_trips,
	d.trip_percentage_diff,
	d.trip_target_status,
	d.avg_passenger_rating,
	d.target_avg_passenger_rating,
	d.rating_percentage_diff,
	d.rating_target_status,
	d.new_passengers,
	d.target_new_passengers,
	d.passenger_percentage_diff,
	d.passenger_target_status
FROM
    differences d
JOIN 
	trips_db.dim_city dc
ON
	d.city_id = dc.city_id
ORDER BY
	city_name,
	months