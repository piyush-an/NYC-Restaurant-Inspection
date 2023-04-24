{{ config(materialized="table") }}

with distinct_action as (select distinct (coalesce(action, 'Unknown')) as action from {{ ref("load_stg_data") }})

select {{ dbt_utils.generate_surrogate_key(["action"]) }} as action_sk, action

from distinct_action
order by 2
