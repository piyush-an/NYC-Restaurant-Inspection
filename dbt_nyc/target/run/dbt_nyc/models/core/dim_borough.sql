
  
    

  create  table "nyc"."target"."dim_borough__dbt_tmp"
  as (
    

with distinct_boro as (select distinct (REPLACE(boro, '0', 'Unknown')) as boro from "nyc"."target"."load_stg_data")

select 
    
md5(cast(coalesce(cast(boro as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as boro_sk, boro

from distinct_boro
order by 2
  );
  