{{
    codegen.generate_source(
        schema_name = 'SQL_SERVER_DBO',
        database_name = 'ALUMNO4_DEV_BRONZE_DB',
        table_names = ['orders','order_items'],
        generate_columns = True,
        include_descriptions=True,
        include_data_types=True,
        name='desarrollo',
        include_database=True,
        include_schema=True
        )
}}