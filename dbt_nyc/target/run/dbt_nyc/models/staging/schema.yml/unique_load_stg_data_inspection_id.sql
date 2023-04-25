select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    inspection_id as unique_field,
    count(*) as n_records

from "nyc"."target"."load_stg_data"
where inspection_id is not null
group by inspection_id
having count(*) > 1



      
    ) dbt_internal_test