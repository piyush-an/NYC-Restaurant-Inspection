{{ config(materialized="table") }}

with distinct_boro as (select distinct (REPLACE(boro, '0', 'Unknown')) as boro from {{ ref("load_stg_data") }})

select {{ dbt_utils.generate_surrogate_key(["boro"]) }} as boro_sk, boro

from distinct_boro
order by 2
