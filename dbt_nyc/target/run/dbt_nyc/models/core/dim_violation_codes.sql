
  
    

  create  table "nyc"."target"."dim_violation_codes__dbt_tmp"
  as (
    

with
    distinct_violation_codes as (
        select distinct coalesce(violation_code, 'Unknown') as violation_code, coalesce(violation_description, 'Unknown') as violation_description
        from "nyc"."target"."load_stg_data"
    )

select
    
    
md5(cast(coalesce(cast(violation_code as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(violation_description as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))
    as violation_code_sk,
    violation_code,
    violation_description

from distinct_violation_codes
order by 2, 3
  );
  