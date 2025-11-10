{{
  config(
    materialized = 'table'
  )
}}

WITH src_addresses AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'ADDRESSES') }}
),

transformed_addresses AS (
    SELECT
       md5(address_id) AS address_id,
       country,
       md5(lower(country)) AS country_id,
       _fivetran_deleted AS fivetran_deleted,
       CONVERT_TIMEZONE('UTC',_fivetran_synced) AS fivetran_synced
    FROM src_addresses)

SELECT * FROM transformed_addresses
