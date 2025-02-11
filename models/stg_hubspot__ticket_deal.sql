{{ config(enabled=(var('hubspot_service_enabled', false) and var('hubspot_ticket_deal_enabled', false))) }}

with base as (

    select *
    from {{ ref('stg_hubspot__ticket_deal_tmp') }}

), macro as (

    select
        {% set default_cols = adapter.get_columns_in_relation(ref('stg_hubspot__ticket_deal_tmp')) %}
        {% set new_cols = fivetran_utils.remove_prefix_from_columns(columns=default_cols, 
            prefix='property_hs_',exclude=get_macro_columns(get_ticket_deal_columns())) %}
        {{
            fivetran_utils.fill_staging_columns(source_columns=default_cols,
                staging_columns=get_ticket_deal_columns()
            )
        }}
        {% if new_cols | length > 0 %} 
            ,{{ new_cols }} 
        {% endif %}
    from base

)

select *
from macro
