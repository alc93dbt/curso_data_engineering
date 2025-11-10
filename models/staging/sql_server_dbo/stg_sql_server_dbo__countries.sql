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
       md5(lower(country)) AS country_id,
       md5(address_id) AS address_id,
       lower(country) AS country,
    FROM src_countries)

SELECT * FROM countries
