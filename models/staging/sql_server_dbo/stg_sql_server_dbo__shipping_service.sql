{{ config(materialized="view") }}

with src_shipping_service as (
    select shipping_service
    from {{ ref("stg_sql_server_dbo__orders") }}
)

select distinct
    {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} as shipping_service_id,
    shipping_service as shipping_service_name
from src_shipping_service
