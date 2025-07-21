with fleet_raw as (
    select "json"::jsonb as aircraft_json
    from {{ ref('seed_aeroplane_model') }}
)
SELECT
    mfr.key                    AS manufacturer,      -- Boeing, Airbus, …
    mdl.key                    AS model,             -- 737‑800, A350‑900, …
    (attrs ->> 'max_seats')    ::int  AS max_seats,
    (attrs ->> 'max_weight')   ::int  AS max_weight,        -- kg
    (attrs ->> 'max_distance') ::int  AS max_distance,      -- nm ou km selon ta source
    attrs ->> 'engine_type'            AS engine_type
FROM   fleet_raw fr
       -- 1. first level : constructors
       CROSS JOIN LATERAL jsonb_each(fr.aircraft_json) AS mfr(key, value)
       -- 2. second level : planes
       CROSS JOIN LATERAL jsonb_each(mfr.value)        AS mdl(key, attrs)
