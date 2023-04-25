
    
    

with all_values as (

    select
        grade as value_field,
        count(*) as n_records

    from "nyc"."target"."load_stg_data"
    group by grade

)

select *
from all_values
where value_field not in (
    'A','B','C','Z','P','N'
)


