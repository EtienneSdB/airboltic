with trip_metadata as (
    select
        orders."Customer ID" as customer_id,
        trip."Start Timestamp"::date as trip_date,
        trip."Origin City",
        trip."Destination City",
        -- when the time is negative, it means we have to add 24h because of time zones reset in the pacific
        case
            when extract(epoch from (trip."End Timestamp" - trip."Start Timestamp")) < 0 then 24 +
                                                                                              extract(epoch from (trip."End Timestamp" - trip."Start Timestamp")) /
                                                                                              60 / 60
            else extract(epoch from (trip."End Timestamp" - trip."Start Timestamp")) / 60 / 60
        end                  as trip_time_in_hours,
        orders."Price (EUR)" as price_in_euro,
        pars_plane.max_seats,
        pars_plane.max_weight,
        pars_plane.max_distance
    from {{ ref('seed_order') }} orders
    left join {{ ref('seed_trip') }} trip
        on trip."Trip ID" = orders."Trip ID"
    left join {{ ref('seed_aeroplane') }} plane
        on trip."Airplane ID" = plane."Airplane ID"
    left join {{ ref('parsing_aeroplane_model') }} pars_plane
        on plane."Airplane Model" = pars_plane.model and plane."Manufacturer" = pars_plane.manufacturer
)
select *
from trip_metadata

