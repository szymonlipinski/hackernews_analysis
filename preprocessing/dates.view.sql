create materialized view dates as
select
object_id,
timestamp 'epoch' + created_at_i * interval '1 second' as date,
date_part('year',   timestamp 'epoch' + created_at_i * interval '1 second') as year,
date_part('month',  timestamp 'epoch' + created_at_i * interval '1 second') as month,
date_part('week',   timestamp 'epoch' + created_at_i * interval '1 second') as week,
date_part('day',    timestamp 'epoch' + created_at_i * interval '1 second') as day,
date_part('dow',    timestamp 'epoch' + created_at_i * interval '1 second') as dow,
date_part('hour',   timestamp 'epoch' + created_at_i * interval '1 second') as hour,
date_part('minute', timestamp 'epoch' + created_at_i * interval '1 second') as minute,
date_part('second', timestamp 'epoch' + created_at_i * interval '1 second') as second,
to_char(timestamp 'epoch' + created_at_i * interval '1 second', 'yyyy-MM')  as year_month
from data;
