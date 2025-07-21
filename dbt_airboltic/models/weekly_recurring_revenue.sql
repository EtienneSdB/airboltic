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
        date_trunc('week', trip_date) as trip_week,
        sum(price_in_euro) as weekly_revenue
    from {{ ref('trip_metadata') }}
    group by date_trunc('week', trip_date)
)
select TO_CHAR(DATE(weeks.week_start), 'IYYY-IW') as week_number,
       coalesce(weekly_revenue, 0) as weekly_revenue
from weeks
left join last_date_activity
on TO_CHAR(DATE(weeks.week_start), 'IYYY-IW') = TO_CHAR(DATE(last_date_activity.trip_week), 'IYYY-IW')