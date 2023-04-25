
    
    

select
    inspection_id as unique_field,
    count(*) as n_records

from "nyc"."target"."load_stg_data"
where inspection_id is not null
group by inspection_id
having count(*) > 1


