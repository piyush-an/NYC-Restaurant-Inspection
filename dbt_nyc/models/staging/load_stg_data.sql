{{ config(materialized="table") }}

with nyc_inspection as (select * from {{ source("staging", "stg_food_inspection") }})

select
    {{ dbt_utils.generate_surrogate_key(["camis", "inspection_date", "violation_code"]) }}
    as inspection_id,
    cast(camis as integer) as buisness_id,
    cast(dba as text) as buisness_name,
    cast(boro as text) as boro,
    cast(building as text) as building,
    cast(street as text) as street,
    cast(zipcode as text) as zipcode,
    cast(phone as text) as phone,
    cast(cuisine_description as text) as cuisine_description,
    cast(inspection_date as date) as inspection_date,
    cast(action as text) as action,
    cast(violation_code as text) as violation_code,
    cast(violation_description as text) as violation_description,
    cast(critical_flag as text) as critical_flag,
    cast(score as integer) as score,
    cast(grade as text) as grade,
    cast(grade_date as date) as grade_date,
    cast(record_date as timestamp) as record_date,
    cast(inspection_type as text) as inspection_type,
    cast(latitude as numeric) as latitude,
    cast(longitude as numeric) as longitude,
    cast(community_board as integer) as community_board,
    cast(council_district as integer) as council_district
from nyc_inspection

-- dbt build --m load_stg_data.sql --var 'is_test_run: false'
{% if var("is_test_run", default=true) %} limit 1000 {% endif %}
