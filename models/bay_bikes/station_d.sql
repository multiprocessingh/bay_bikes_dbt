/*
    Model for the station_d table
*/

{{ config(materialized='table') }}

select distinct start_station_id as id,
       start_station_name as station_name,
       start_station_latitude as station_latitude,
       start_station_longitude as station_longitude
from {{ source('public', 'trips_staging') }}
union
select distinct end_station_id as id,
       end_station_name as station_name,
       end_station_latitude as station_latitude,
       end_station_longitude as station_longitude
from {{ source('public', 'trips_staging') }}
