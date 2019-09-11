-- precalculated dates from created_at_i
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
date_part('second', timestamp 'epoch' + created_at_i * interval '1 second') as second
from data;


-- indices for the view tables
create index i_dates_object_id on dates(object_id);
create index i_dates_year on dates(year);
create index i_dates_month on dates(month);


create materialized view 
urls as
select
    distinct
    object_id, "comment_text" as type,
    unnest(
        regexp_matches(lower(comment_text), '\W([\.\w\d]*://[\.\w\d]*)\W',  'g')
    ) url
from data
UNION ALL
select
    distinct
    object_id, "story_title",
    unnest(
        regexp_matches(lower(title), '\W([\.\w\d]*://[\.\w\d]*)\W',  'g')
    ) url
from data
UNION ALL
select
    distinct
    object_id, "story_text",
    unnest(
        regexp_matches(lower(story_text), '\W([\.\w\d]*://[\.\w\d]*)\W',  'g')
    ) url
from data;

create index i_urls_object_id on urls(object_id);

