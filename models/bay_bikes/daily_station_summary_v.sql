/*

View to summarize daily metrics about certain stations.

*/

{{ config(materialized='view') }}


with daily_station_check_outs as (
    select t.start_station_id as station_id,
           s.station_name,
           DATE(t.start_time) as dw_eff_dt,
           count(*) as num_check_outs
    from {{ ref("trips_f") }} as t
    join {{ ref("station_d") }} as s
      on t.start_station_id = s.id
    group by 1,2,3
),
daily_station_check_ins as (
    select t.end_station_id as station_id,
       s.station_name,
       DATE(t.end_time) as dw_eff_dt,
       count(*) as num_check_ins
    from {{ ref("trips_f") }} as t
    join {{ ref("station_d") }} as s
      on t.end_station_id = s.id
    group by 1,2,3
)
select o.station_name,
       o.dw_eff_dt,
       o.num_check_outs,
       i.num_check_ins,
       i.num_check_ins - o.num_check_outs as sink_factor
from daily_station_check_outs o
join daily_station_check_ins i
  on o.station_id = i.station_id and o.dw_eff_dt=i.dw_eff_dt


