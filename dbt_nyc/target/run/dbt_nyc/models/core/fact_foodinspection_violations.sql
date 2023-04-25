
  
    

  create  table "nyc"."target"."fact_foodinspection_violations__dbt_tmp"
  as (
    

with
    stg_inspection as (select 
    -- * 
    score,
    grade_date,
    critical_flag,
    phone,
    inspection_date,
    coalesce(grade, 'Unknown') as grade,
    coalesce(violation_code, 'Unknown') as violation_code, 
    coalesce(violation_description, 'Unknown') as violation_description,
    coalesce(inspection_type, 'Unknown') as inspection_type,
    coalesce(action, 'Unknown') as action
    
    from "nyc"."target"."load_stg_data"),
    fact_food_inspections as (select * from "nyc"."target"."fact_food_inspections"),

    dim_critical_flag as (select * from "nyc"."target"."dim_critical_flag"),
    dim_inspection_actions as (select * from "nyc"."target"."dim_inspection_actions"),
    dim_inspection_grades as (select * from "nyc"."target"."dim_inspection_grades"),
    dim_inspection_type as (select * from "nyc"."target"."dim_inspection_type"),
    dim_violation_codes as (select * from "nyc"."target"."dim_violation_codes")

select
    
    
md5(cast(coalesce(cast(inspection_sk as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(inspection_type_sk as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(action_sk as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(critical_flag_sk as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(score as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(grade_sk as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(violation_code_sk as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as inspection_violation_sk,
    food_inspections.inspection_sk as inspection_sk,
    inspection_type.inspection_type_sk as inspection_type_sk,
    inspection_actions.action_sk as action_sk,
    critical_flag.critical_flag_sk as critical_flag_sk,
    stg_inspection.score as score,
    inspection_grades.grade_sk as grade_sk,
    violation_codes.violation_code_sk as violation_code_sk
    -- stg_inspection.record_date as record_date

from stg_inspection

inner join
    dim_critical_flag as critical_flag
    on stg_inspection.critical_flag = critical_flag.critical_flag
inner join
    dim_inspection_grades as inspection_grades
    on stg_inspection.grade = inspection_grades.grade
inner join
    dim_inspection_type as inspection_type
    on stg_inspection.inspection_type = inspection_type.inspection_type
inner join
    dim_inspection_actions as inspection_actions
    on stg_inspection.action = inspection_actions.action
inner join
    dim_violation_codes as violation_codes
    on stg_inspection.violation_code = violation_codes.violation_code
    and stg_inspection.violation_description = violation_codes.violation_description
inner join
    fact_food_inspections as food_inspections
    on stg_inspection.inspection_date = food_inspections.inspection_date
    and stg_inspection.phone = food_inspections.phone
  );
  