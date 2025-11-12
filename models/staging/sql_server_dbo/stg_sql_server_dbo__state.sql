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
       {{ surrogate_key(['country']) }} as country_id,
       {{ surrogate_key(['address_id']) }} as address_id,
       lower(state) AS state
    FROM src_state)

SELECT * FROM state

