#!/bin/bash


psql -tX -U hn hn -c "select 'drop table ' || tablename || ' cascade' from pg_tables where schemaname='public';" | psql -U hn hn
psql -tX -U hn hn -c "select 'drop materialized view ' ||  matviewname || ' cascade' from pg_matviews where schemaname='public';" | psql -U hn hn
