{{ config(materialized="view") }}

with src_status as (
    select status
    from {{ ref("base_sql_server_dbo__orders") }}
)

select distinct
    {{ surrogate_key(['status']) }} as status_id,,
    status as status_name
from src_status