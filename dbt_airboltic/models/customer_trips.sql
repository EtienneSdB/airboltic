with trip_custo as (
    select
        custo."Customer ID" as customer_id,
        trip."Start Timestamp"::date as trip_date,
        case when custo_group."ID" is not null then custo_group."Type"||' - '||custo_group."Name"
            else 'Customer'||' - '||custo."Customer ID" end as customer_group_or_id,
        case when custo_group."ID" is not null then custo_group."Type"
            else 'Customer' end as customer_type,
        case when orders."Status" = 'Finished' then 1 else 0 end as is_order_finished
    from {{ ref('seed_order') }} orders
    left join {{ ref('seed_trip') }} trip
        on trip."Trip ID" = orders."Trip ID"
    left join {{ ref('seed_customer') }} custo
        on orders."Customer ID" = custo."Customer ID"
    left join {{ ref('seed_customer_group') }} custo_group
        on custo."Customer Group ID" = custo_group."ID"
    where orders."Status" in ('Finished', 'Cancelled')
)
select * from trip_custo
