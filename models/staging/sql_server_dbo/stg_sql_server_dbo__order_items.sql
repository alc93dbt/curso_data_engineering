{{ 
  config(
    materialized = 'view'
  )
}}

WITH src_order_items AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'order_items') }}
),

transformed_order_items AS (
    SELECT
        md5(order_id) AS order_id,
        md5(product_id) AS product_id,
        CAST(quantity AS INTEGER) AS quantity,
        _fivetran_deleted AS fivetran_deleted,
        _fivetran_synced AS fivetran_synced
    FROM src_order_items
)

SELECT * FROM transformed_order_items
