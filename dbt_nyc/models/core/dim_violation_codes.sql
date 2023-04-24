{{ config(materialized="table") }}

with
    distinct_violation_codes as (
        select distinct coalesce(violation_code, 'Unknown') as violation_code, coalesce(violation_description, 'Unknown') as violation_description
        from {{ ref("load_stg_data") }}
    )

select
    {{ dbt_utils.generate_surrogate_key(["violation_code", "violation_description"]) }}
    as violation_code_sk,
    violation_code,
    violation_description

from distinct_violation_codes
order by 2, 3
