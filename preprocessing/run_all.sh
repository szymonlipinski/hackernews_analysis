#!/bin/bash

PSQL="psql -U hn hn"

echo "Removing existing tables and views"
./remove_tables.sh

echo "Creating basic table"
$PSQL < raw_data.create.sql

echo "Loading data"
./load_files.sh hn hn raw_data /home/data/hn

echo "Removing duplicates"
$PSQL < clean_duplicates.sql

echo "Creating indices for data"
$PSQL < indices.sql

echo "Creating dates materialied view"
$PSQL < dates.view.sql

echo "Creating indices for dates view"
$PSQL < dates.view.indices.sql

echo "Creating urls view"
$PSQL < urls.view.sql

echo "Creating urls view indices"
$PSQL < urls.view.indices.sql
