
    
    

with all_values as (

    select
        critical_flag as value_field,
        count(*) as n_records

    from "nyc"."target"."load_stg_data"
    group by critical_flag

)

select *
from all_values
where value_field not in (
    'Critical','Not Critical','Not Applicable'
)


