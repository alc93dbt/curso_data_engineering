{{
  config(
    materialized = 'view'
  )
}}

WITH src_countries AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__addresses') }}
),

countries AS (
    SELECT DISTINCT
       {{ surrogate_key(['country']) }} as country_id,
       {{ surrogate_key(['address_id']) }} as address_id,
       lower(country) AS country,
    FROM src_countries)

SELECT * FROM countries
