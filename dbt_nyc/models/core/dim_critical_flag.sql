{{ config(materialized="table") }}

with
    distinct_critical_flag as (
        select distinct (critical_flag) as critical_flag from {{ ref("load_stg_data") }}
    )

select
    {{ dbt_utils.generate_surrogate_key(["critical_flag"]) }} as critical_flag_sk, critical_flag

from distinct_critical_flag
order by 2
