{{ config(materialized="view") }}

WITH src_events AS (
    SELECT * 
    FROM {{ source("sql_server_dbo", "events") }}
),

cleaned_events AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['event_id']) }} as event_id,,

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

        {{ dbt_utils.generate_surrogate_key(['user_id']) }} as user_id,
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_id,
        {{ dbt_utils.generate_surrogate_key(['session_id']) }} as session_id,
        {{ dbt_utils.generate_surrogate_key(['oder_id']) }} as order_id,

        
        convert_timezone('UTC', created_at) AS created_at,
        _fivetran_deleted AS fivetran_deleted,
        convert_timezone('UTC', _fivetran_synced) AS fivetran_synced

    FROM src_events
)

SELECT *
FROM cleaned_events
