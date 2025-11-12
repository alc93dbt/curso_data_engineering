{{ config(materialized="view") }}

with src_shipping_service as (
    select shipping_service
    from {{ ref("base_sql_server_dbo__orders") }}
)

select distinct
    {{ surrogate_key(['shipping_service']) }} as shipping_service_id,
    shipping_service as shipping_service_name
from src_shipping_service
