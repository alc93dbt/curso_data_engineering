{{ config(materialized="view") }}

WITH src_events AS (
    SELECT * 
    FROM {{ source("sql_server_dbo", "events") }}
),

cleaned_events AS (
    SELECT
        md5(event_id) AS event_id,

        -- Limpieza de URL
        lower(trim(page_url)) AS page_url_clean,
        regexp_substr(lower(trim(page_url)), '^[^?]+') AS page_path,
        regexp_substr(lower(trim(page_url)), 'utm_source=([^&]+)', 1, 1, 'e', 1) AS utm_source,

        -- Clasificación de tipo de página
        CASE
            WHEN page_url ILIKE '%checkout%' THEN 'checkout'
            WHEN page_url ILIKE '%product%' THEN 'product_page'
            WHEN page_url ILIKE '%cart%' THEN 'cart'
            ELSE 'other'
        END AS page_category,

        lower(trim(event_type)) AS event_type,

        --Normalización claves foráneas
        md5(coalesce(user_id, 'no_user')) AS user_id,
        md5(coalesce(product_id, 'no_product')) AS product_id,
        md5(coalesce(session_id, 'no_session')) AS session_id,
        md5(coalesce(order_id, 'no_order')) AS order_id,
        
        convert_timezone('UTC', created_at) AS created_at,
        _fivetran_deleted AS fivetran_deleted,
        convert_timezone('UTC', _fivetran_synced) AS fivetran_synced

    FROM src_events
)

SELECT *
FROM cleaned_events
