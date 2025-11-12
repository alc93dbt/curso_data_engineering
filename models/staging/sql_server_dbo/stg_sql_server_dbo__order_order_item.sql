{{
  config(
    materialized = 'view'
  )
}}

WITH src_order_with_order_items AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'order_items') }}
),

order_order_items AS (
    SELECT
        {{ surrogate_key(['order_id']) }} as order_id,
        {{ surrogate_key(['order_item']) }} as order_item_id,
        CAST(quantity AS INTEGER) AS quantity,
        _fivetran_deleted AS fivetran_deleted,
        _fivetran_synced AS fivetran_synced
    FROM src_order_items
)

SELECT * FROM transformed_order_items
