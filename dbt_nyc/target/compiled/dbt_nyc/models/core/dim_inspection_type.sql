

with
    distinct_inspection_type as (
        select distinct (coalesce(inspection_type, 'Unknown')) as inspection_type from "nyc"."target"."load_stg_data"
    )

select
    
    
md5(cast(coalesce(cast(inspection_type as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as inspection_type_sk,
    inspection_type

from distinct_inspection_type
order by 2