{{ config(materialized="view") }}

with src_status as (
    select status
    from {{ ref("stg_sql_server_dbo__orders") }}
)

select distinct
    {{ dbt_utils.generate_surrogate_key(['status']) }} as status_id,,
    status as status_name
from src_status