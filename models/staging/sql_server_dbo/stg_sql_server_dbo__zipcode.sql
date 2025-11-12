{{ config(materialized="view") }}

with
    src_countries as (select * from {{ ref("stg_sql_server_dbo__addresses") }}),

    countries as (
        select distinct
            {{ surrogate_key(["country_id"]) }} as country_id,
            {{ surrogate_key(["address_id"]) }} as address_id,
            lower(country) as country,
        from src_countries
    )

select *
from countries
