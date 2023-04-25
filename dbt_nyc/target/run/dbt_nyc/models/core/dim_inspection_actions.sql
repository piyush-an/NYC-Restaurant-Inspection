
  
    

  create  table "nyc"."target"."dim_inspection_actions__dbt_tmp"
  as (
    

with distinct_action as (select distinct (coalesce(action, 'Unknown')) as action from "nyc"."target"."load_stg_data")

select 
    
md5(cast(coalesce(cast(action as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as action_sk, action

from distinct_action
order by 2
  );
  