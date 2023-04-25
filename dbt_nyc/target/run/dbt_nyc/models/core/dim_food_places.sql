
  
    

  create  table "nyc"."target"."dim_food_places__dbt_tmp"
  as (
    

with
    distinct_food_places as (
        select distinct buisness_id, coalesce(buisness_name, 'Unknown') as buisness_name from "nyc"."target"."load_stg_data"
    )

select
    
    
md5(cast(coalesce(cast(buisness_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(buisness_name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as foodplace_sk,
    buisness_id,
    buisness_name
from distinct_food_places
ORDER BY 3
  );
  