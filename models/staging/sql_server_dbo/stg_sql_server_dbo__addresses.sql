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
       {{ surrogate_key(['address_id']) }} as address_id,
       {{ surrogate_key(['country']) }} as country_id,
       {{ surrogate_key(['address']) }} as address_details_id,

       _fivetran_deleted AS fivetran_deleted,
       CONVERT_TIMEZONE('UTC',_fivetran_synced) AS fivetran_synced
    FROM src_addresses)

SELECT * FROM transformed_addresses
