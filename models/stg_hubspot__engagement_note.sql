{{ config(enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_engagement_enabled','hubspot_engagement_note_enabled'])) }}

with base as (

    select *
    from {{ ref('stg_hubspot__engagement_note_tmp') }}

), macro as (

    select
        {% set default_cols = adapter.get_columns_in_relation(ref('stg_hubspot__engagement_note_tmp')) %}
        {% set new_cols = fivetran_utils.remove_prefix_from_columns(columns=default_cols, 
            prefix='property_hs_',exclude=get_macro_columns(get_engagement_note_columns())) %}
        {{
            fivetran_utils.fill_staging_columns(source_columns=default_cols,
                staging_columns=get_engagement_note_columns()
            )
        }}
        {% if new_cols | length > 0 %} 
            ,{{ new_cols }} 
        {% endif %}
    from base

)

select *
from macro


