{% macro remove_column_conflict(columns, conflict_pair, keep) %}
    {# If both columns in the conflict_pair exist, we will only keep the one specified in the keep variable #}
    {% set new_col_list = [] %}
    {% set keep = keep.lower() %}
    {% set conflict_pair = conflict_pair[0].lower(), conflict_pair[1].lower() %}
    
    {# First pass to check if both items in conflict pair are present #}
    {% set conflict_exists = false %}
    {% set first_item_exists = false %}
    {% set second_item_exists = false %}

    {% for column in columns %}
        {% set lower_column = column.column.lower() %}
        {{print(lower_column)}}
        {% if lower_column == conflict_pair[0] %}
            {{print('match 0')}}
            {% set first_item_exists = true %}
        {% elif lower_column == conflict_pair[1] %}
            {{print('match 1')}}
            {% set second_item_exists = true %}
        {% else %}
            {{print('no match')}}
        {% endif %}
    {% endfor %}
    
    {% if first_item_exists and second_item_exists %}
        {% set conflict_exists = true %}
    {% endif %}

    {# Second pass to build the column list #}
    {% for column in columns %}
        {% set lower_column = column.column.lower() %}
        {% if conflict_exists %}
            {% if lower_column == keep %}
                {% set new_col_list = new_col_list + [column] %}
            {% endif %}
        {% else %}
            {% set new_col_list = new_col_list + [column] %}
        {% endif %}
    {% endfor %}

    {{print(conflict_exists)}}
    --{{print(columns)}}
    {{print(new_col_list)}}
    {{ return(new_col_list) }}
{% endmacro %}
