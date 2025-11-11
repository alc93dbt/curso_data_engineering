{{ config(materialized = 'view') }}

WITH src_inventory AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__products') }}
),

clean_inventory AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_id, 
        COALESCE(CAST(inventory AS INTEGER), 0) AS stock_units
    FROM src_inventory
)

SELECT * FROM clean_inventory
