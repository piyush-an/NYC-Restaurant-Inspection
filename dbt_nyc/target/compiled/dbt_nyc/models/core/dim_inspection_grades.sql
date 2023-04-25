

with distinct_grade as (select distinct (coalesce(grade, 'Unknown')) as grade from "nyc"."target"."load_stg_data")

select 
    
md5(cast(coalesce(cast(grade as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as grade_sk, grade

from distinct_grade
order by 2