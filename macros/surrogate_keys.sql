{% macro surrogate_key(column_name) %}
    {{ dbt_utils.generate_surrogate_key([column_name]) }}
{% endmacro %}