{{
  config(
    materialized = 'table'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
),

renamed_promo AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_id,,
        promo_id AS promo_name,
        CAST(discount AS FLOAT) AS discount,
        lower(status) AS status,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced ) AS fivetran_synced
    FROM src_promos
),

no_promo AS (
    SELECT 
        md5('no_promo') AS promo_id,
        'no_promo' AS promo_name,
        0.0 AS discount,
        'inactive' AS status,
        NULL AS _fivetran_deleted,
        CURRENT_TIMESTAMP() AS fivetran_synced
)
SELECT * FROM renamed_promo
UNION ALL
SELECT * FROM no_promo
