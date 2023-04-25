

with
    distinct_critical_flag as (
        select distinct (critical_flag) as critical_flag from "nyc"."target"."load_stg_data"
    )

select
    
    
md5(cast(coalesce(cast(critical_flag as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as critical_flag_sk, critical_flag

from distinct_critical_flag
order by 2