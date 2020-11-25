/*
    Model for the user_types_d table
*/

{{ config(materialized='table') }}

select row_number() over (order by user_type asc) as id,
        user_type
from {{ source('public', 'trips_staging') }}
group by user_type
