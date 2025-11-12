{{ config(materialized="view") }}

with
    src_orders as (select * from {{ source("sql_server_dbo", "orders") }}),

    transformed_orders as (
        select
            {{ surrogate_key(["order_id"]) }} as order_id,
            {{ surrogate_key(["status"]) }} as status_id,
            {{ surrogate_key(["shipping_service"]) }}
            as shipping_service_id,
            cast(shipping_cost as decimal(10, 2)) as shipping_cost,
            {{ surrogate_key(["address_id"]) }} as address_id,
            created_at,
            {{
                surrogate_key(
                    ["coalesce(cast(promo_id as varchar), ''), 'no_promo')"]
                )
            }} as promo_id,
            estimated_delivery_at,
            cast(order_cost as decimal(10, 2)) as order_cost,
            {{ surrogate_key(["user_id"]) }} as user_id,
            cast(order_total as decimal(10, 2)) as order_total,
            delivered_at,
            tracking_id,
            _fivetran_deleted as fivetran_deleted,
            _fivetran_synced as fivetran_synced
        from src_orders
    )

select *
from transformed_orders
