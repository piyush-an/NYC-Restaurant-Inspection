{{ config(materialized="table") }}
with
    distinct_address as (
        select distinct
            coalesce(building, 'Unknown') as building,
            coalesce(street, 'Unknown') as street,
            coalesce(zipcode, 'Unknown') as zipcode,
            REPLACE(boro, '0', 'Unknown') as boro,
            -- NULLIF(latitude, 0) as latitude,
            -- NULLIF(longitude, 0) as longitude,
            case when latitude isnull or latitude = 0 then -99999 else latitude end as latitude,
            case when longitude isnull or longitude = 0 then -99999 else longitude end as longitude,
            coalesce(community_board, -1.0) as community_board,
            coalesce(council_district, -1.0) as council_district
        from {{ ref("load_stg_data") }}
    )

select
    {{
        dbt_utils.generate_surrogate_key(
            [
                "building",
                "street",
                "boro"
            ]
        )
    }} as address_sk,
    building,
    street,
    zipcode,
    boro,
    latitude,
    longitude,
    community_board,
    council_district

from distinct_address
order by 5,3,2
