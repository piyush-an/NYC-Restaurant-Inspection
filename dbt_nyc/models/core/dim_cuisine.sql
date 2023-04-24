{{ config(materialized="table") }}

with
    distinct_cuisine_description as (
        select distinct (coalesce(cuisine_description, 'Unknown')) as cuisine_description from {{ ref("load_stg_data") }}
    )

select
    {{ dbt_utils.generate_surrogate_key(["cuisine_description"]) }} as cuisine_description_sk,
    cuisine_description

from distinct_cuisine_description
order by 2
