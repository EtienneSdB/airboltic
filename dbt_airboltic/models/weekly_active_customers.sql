with weeks AS (
    SELECT
        generate_series(
            date_trunc('week', '2024-07-25'::date),
            date_trunc('week', '2024-09-05'::date),
            interval '1 week'
        )::date AS week_start
),
last_date_activity as (
    select
        custo."Customer ID" as customer_id,
        max(trip.trip_date) as last_trip_date,
        date_trunc('week', max(trip.trip_date)::date) as last_trip_week
    from {{ref('seed_customer')}} custo
    left join {{ref('customer_trips')}} trip
        on custo."Customer ID" = trip.customer_id
    group by custo."Customer ID"
)
select TO_CHAR(DATE(weeks.week_start), 'IYYY-IW') as week_number,
       count(distinct customer_id) as customer_number
from weeks
left join last_date_activity
on TO_CHAR(DATE(weeks.week_start), 'IYYY-IW') = TO_CHAR(DATE(last_date_activity.last_trip_week), 'IYYY-IW')
group by TO_CHAR(DATE(weeks.week_start), 'IYYY-IW')