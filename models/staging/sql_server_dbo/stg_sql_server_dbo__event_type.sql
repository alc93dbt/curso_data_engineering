{{ config(materialized="view") }}

with src_events as (select event_type from {{ source("sql_server_dbo", "events") }})

select distinct
    {{ surrogate_key(["event_type"]) }} as event_type_id,
    lower(trim(event_type)) as event_type_name
from src_events
where event_type is not null and trim(event_type) <> ''
