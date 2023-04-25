

with
    distinct_cuisine_description as (
        select distinct (coalesce(cuisine_description, 'Unknown')) as cuisine_description from "nyc"."target"."load_stg_data"
    )

select
    
    
md5(cast(coalesce(cast(cuisine_description as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as cuisine_description_sk,
    cuisine_description

from distinct_cuisine_description
order by 2