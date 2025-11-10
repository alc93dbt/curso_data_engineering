{{
  config(
    materialized = 'view'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
),

transformed_users AS (
    SELECT
        md5(user_id) AS user_id,
        CONVERT_TIMEZONE('UTC', updated_at) AS updated_at,
        md5(address_id) as address_id,
        lower(last_name) as last_name, 
        CONVERT_TIMEZONE('UTC', created_at) AS created_at,
        CASE
            WHEN phone_number IS NULL OR trim(phone_number) = '' THEN 'no_phone'
            WHEN NOT regexp_like(phone_number, '^[0-9+() -]{7,15}$')
                THEN 'invalid_phone'
            ELSE regexp_replace(phone_number, '[^0-9+]', '')
        END AS phone_number,
        total_orders,
        lower(first_name) as first_name,
        CASE
            WHEN email IS NULL OR trim(email) = '' THEN 'no_email'
            WHEN NOT regexp_like(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
                THEN 'invalid_email'
            ELSE lower(email)
        END AS email,
        _fivetran_deleted AS fivetran_deleted,
        CONVERT_TIMEZONE('UTC',_fivetran_synced) AS fivetran_synced

    FROM src_users
)
SELECT * FROM transformed_users

