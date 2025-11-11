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
       {{ dbt_utils.generate_surrogate_key(['address_id']) }} as address_id,
       {{ dbt_utils.generate_surrogate_key(['country']) }} as country_id,
       _fivetran_deleted AS fivetran_deleted,
       CONVERT_TIMEZONE('UTC',_fivetran_synced) AS fivetran_synced
    FROM src_addresses)

SELECT * FROM transformed_addresses
