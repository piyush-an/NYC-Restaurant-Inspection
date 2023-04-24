{{ config(materialized="table") }}

with
    distinct_food_places as (
        select distinct buisness_id, coalesce(buisness_name, 'Unknown') as buisness_name from {{ ref("load_stg_data") }}
    )

select
    {{ dbt_utils.generate_surrogate_key(["buisness_id", "buisness_name"]) }} as foodplace_sk,
    buisness_id,
    buisness_name
from distinct_food_places
ORDER BY 3
