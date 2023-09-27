{{ config(enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_engagement_enabled','hubspot_engagement_meeting_enabled'])) }}

with base as (

    select *
    from {{ ref('stg_hubspot__engagement_meeting_tmp') }}

), macro as (

    select
        {% set default_cols = adapter.get_columns_in_relation(ref('stg_hubspot__engagement_meeting_tmp')) %}
        {% set new_cols = fivetran_utils.remove_prefix_from_columns(columns=default_cols, 
            prefix='property_hs_',exclude=get_macro_columns(get_engagement_meeting_columns())+['MEETING_OUTCOME','MEETING_CHANGE_ID','INTERNAL_MEETING_NOTES','ATTENDEE_OWNER_IDS','I_CAL_UID']) %}
        {{
            fivetran_utils.fill_staging_columns(source_columns=default_cols,
                staging_columns=get_engagement_meeting_columns()
            )
        }}
        {% if new_cols | length > 0 %} 
            ,{{ new_cols }} 
        {% endif %}
    from base

)

select *
from macro


