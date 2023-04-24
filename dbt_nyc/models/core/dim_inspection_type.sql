{{ config(materialized="table") }}

with
    distinct_inspection_type as (
        select distinct (coalesce(inspection_type, 'Unknown')) as inspection_type from {{ ref("load_stg_data") }}
    )

select
    {{ dbt_utils.generate_surrogate_key(["inspection_type"]) }} as inspection_type_sk,
    inspection_type

from distinct_inspection_type
order by 2
