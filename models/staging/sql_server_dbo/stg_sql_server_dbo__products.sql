{{ config(materialized = 'view') }}

WITH src_products AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'products') }}
),

clean_products AS (
    SELECT
        md5(product_id) AS product_id,
        INITCAP(TRIM(REGEXP_REPLACE(name, '[^a-zA-Z0-9 ]', ''))) AS product_name,
        CASE
            WHEN price IS NULL OR price < 0 THEN 0.00
            ELSE CAST(price AS DECIMAL(10, 2))
        END AS price,
        _fivetran_deleted AS fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS fivetran_synced
    FROM src_products
)

SELECT * FROM clean_products
