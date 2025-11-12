{{ config(materialized="view") }}

with
    src_address_details as (select * from {{ source("sql_server_dbo", "ADDRESSES") }}),

    address_details AS (
    SELECT DISTINCT
        {{ surrogate_key(['address']) }} AS address_details_id,
        CASE
            WHEN REGEXP_INSTR(address, '^[0-9]') = 1
            THEN TO_NUMBER(REGEXP_SUBSTR(address, '^[0-9]+'))
            ELSE NULL
        END AS street_number,
        LTRIM(
            CASE
                WHEN REGEXP_INSTR(address, '^[0-9]') = 1
                THEN REGEXP_SUBSTR(address, '[^0-9].*')
                ELSE address
            END
        ) AS street_name
    FROM src_address_details
)

select *
from address_details
