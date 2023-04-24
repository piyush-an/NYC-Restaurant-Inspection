{{ config(materialized="table") }}

with distinct_grade as (select distinct (coalesce(grade, 'Unknown')) as grade from {{ ref("load_stg_data") }})

select {{ dbt_utils.generate_surrogate_key(["grade"]) }} as grade_sk, grade

from distinct_grade
order by 2
