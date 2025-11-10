{{ config(materialized='view') }}

WITH src_events AS (
    SELECT event_type
    FROM {{ source('sql_server_dbo', 'events') }}
)

SELECT DISTINCT
    md5(lower(trim(event_type))) AS event_type_id,
    lower(trim(event_type)) AS event_type_name
FROM src_events
WHERE event_type IS NOT NULL AND trim(event_type) <> ''
