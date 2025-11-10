{{ config(materialized="view") }}

with
    src_orders as (select * from {{ source("sql_server_dbo", "orders") }}),

    transformed_orders as (
        select
            md5(order_id) as order_id,
            md5(status) as status_id,
            md5(shipping_service) as shipping_service_id,
            cast(shipping_cost as decimal(10, 2)) as shipping_cost,
            md5(address_id) as address_id,
            created_at,
            coalesce(md5(nullif(trim(cast(promo_id as varchar)), ''))
                        )
                    then md5(nullif(trim(cast(promo_id as varchar)), ''))
                    else md5('no_promo')
                end,
                md5('no_promo')
            ) as promo_id,
            estimated_delivery_at,
            cast(order_cost as decimal(10, 2)) as order_cost,
            md5(user_id) as user_id,
            cast(order_total as decimal(10, 2)) as order_total,
            delivered_at,
            tracking_id,
            _fivetran_deleted as fivetran_deleted,
            _fivetran_synced as fivetran_synced
        from src_orders
    )

select *
from transformed_orders
