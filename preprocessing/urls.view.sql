-- The urls can be everywhere
-- If the entry type is a story, then it has fields like: title, url
-- If it's a comment, then it has comment_text, story_title, story_url
-- Jobs can have url, title, and story_text
create materialized view 
urls as
with url_data as 
(
    select
        distinct
        object_id, 'comment_text' as type,
        unnest(
            regexp_matches(lower(comment_text), '((?:http|https)://[a-zA-Z0-9][a-zA-Z0-9\.-]*\.[a-zA-Z]{2,}/?[^\s<"]*)',  'g')
        ) url
    from data
    UNION ALL
    select
        distinct
        object_id, 'story_title',
        unnest(
            regexp_matches(lower(title), '((?:http|https)://[a-zA-Z0-9][a-zA-Z0-9\.-]*\.[a-zA-Z]{2,}/?[^\s<"]*)',  'g')
        ) url
    from data
    UNION ALL
    select
        distinct
        object_id, 'story_text',
        unnest(
            regexp_matches(lower(story_text), '((?:http|https)://[a-zA-Z0-9][a-zA-Z0-9\.-]*\.[a-zA-Z]{2,}/?[^\s<"]*)',  'g')
        ) url
    from data
    UNION ALL
    select
        distinct
        object_id, 'url',
        unnest(
            regexp_matches(lower(url), '((?:http|https)://[a-zA-Z0-9][a-zA-Z0-9\.-]*\.[a-zA-Z]{2,}/?[^\s<"]*)',  'g')
        ) url
    from data
),
clean_urls as (
     SELECT DISTINCT object_id, type, rtrim(url, './') as url
     FROM url_data
     WHERE url not like '%...'
),
parts as (
 SELECT 
    object_id, type, rtrim(url, './') as url,
    (regexp_matches(url, '^(\w*)://[^/]*/?.*/?$')::TEXT[])[1] as protocol,
    (regexp_matches(url, '^\w*://([^/]*)/?.*/?$')::TEXT[])[1] as domain,
    (regexp_matches(url, '^\w*://(?:www.)?([a-zA-Z0-9_\.-]*).*$')::TEXT[])[1] as domain_without_www,
    (regexp_matches(url, '^\w*://[^/]*(/.*)/?$')::TEXT[])[1] as full_path,
    (regexp_matches(url, '^\w*://[^/]*/.*/?\?(.*)/?$')::TEXT[])[1] as params,
    (regexp_matches(url, '^\w*://[^/]*(/[^?#]*?)/?')::TEXT[])[1] as path
 FROM clean_urls
)
select
 * 
from parts;
