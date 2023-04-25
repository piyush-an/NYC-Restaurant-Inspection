

with
    stg_inspection as (select 
        buisness_id, 
        coalesce(buisness_name, 'Unknown') as buisness_name,
        inspection_date,
        REPLACE(boro, '0', 'Unknown') as boro,
        coalesce(building, 'Unknown') as building,
        coalesce(street, 'Unknown') as street,
        coalesce(zipcode, 'Unknown') as zipcode,
        -- NULLIF(latitude, 0) as latitude,
        -- NULLIF(longitude, 0) as longitude,
        case when latitude isnull or latitude = 0 then -99999 else latitude end as latitude,
        case when longitude isnull or longitude = 0 then -99999 else longitude end as longitude,
        coalesce(community_board, -1.0) as community_board,
        coalesce(council_district, -1.0) as council_district,
        phone,
        coalesce(cuisine_description, 'Unknown') as cuisine_description
     from "nyc"."target"."load_stg_data"),
    dim_addresses as (select * from "nyc"."target"."dim_addresses"),
    dim_borough as (select * from "nyc"."target"."dim_borough"),
    dim_cuisine as (select * from "nyc"."target"."dim_cuisine"),
    dim_food_places as (select * from "nyc"."target"."dim_food_places")

select
    distinct 
    
md5(cast(coalesce(cast(inspection_date as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(phone as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))
    as inspection_sk,
    stg_inspection.inspection_date as inspection_date,
    food_places.foodplace_sk as foodplace_sk,
    borough.boro_sk as boro_sk,
    addresses.address_sk as address_sk,
    stg_inspection.phone as phone,
    cuisine.cuisine_description_sk as cuisine_description_sk
from stg_inspection
inner join dim_borough as borough on stg_inspection.boro = borough.boro
inner join
    dim_food_places as food_places
    on stg_inspection.buisness_id = food_places.buisness_id
    and stg_inspection.buisness_name = food_places.buisness_name
inner join
    dim_addresses as addresses
    on stg_inspection.building = addresses.building
    and stg_inspection.street = addresses.street
    and stg_inspection.boro = addresses.boro
    and stg_inspection.zipcode = addresses.zipcode
    and stg_inspection.latitude = addresses.latitude
    and stg_inspection.longitude = addresses.longitude
    and stg_inspection.community_board = addresses.community_board
    and stg_inspection.council_district = addresses.council_district
inner join
    dim_cuisine as cuisine
    on stg_inspection.cuisine_description = cuisine.cuisine_description