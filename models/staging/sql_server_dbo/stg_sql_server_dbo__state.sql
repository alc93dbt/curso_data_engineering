{{
  config(
    materialized = 'view'
  )
}}

WITH src_state AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__addresses') }}
),

state AS (
    SELECT DISTINCT
       md5(lower(country)) AS country_id,
       md5(address_id) AS address_id,
       lower(state) AS state
    FROM src_state)

SELECT * FROM state

