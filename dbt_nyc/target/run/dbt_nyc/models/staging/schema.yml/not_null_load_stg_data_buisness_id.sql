select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select buisness_id
from "nyc"."target"."load_stg_data"
where buisness_id is null



      
    ) dbt_internal_test