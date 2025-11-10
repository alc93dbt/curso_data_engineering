{{ config(materialized = 'view') }}

WITH src_inventory AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__products') }}
),

clean_inventory AS (
    SELECT
        md5(product_id) AS product_id, 
        COALESCE(CAST(inventory AS INTEGER), 0) AS stock_units
    FROM src_inventory
)

SELECT * FROM clean_inventory
