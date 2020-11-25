/*
    Model for the trips_f table
*/

{{ config(materialized='table') }}

select row_number() over(order by t.*) as id,
       t.duration_sec,
       t.start_time,
       t.end_time,
       t.start_station_id,
       t.end_station_id,
       t.bike_id,
       u.id as user_type_id
from {{ source('public', 'trips_staging') }} as t
join {{ ref("user_types_d") }} as u
  on t.user_type = u.user_type
