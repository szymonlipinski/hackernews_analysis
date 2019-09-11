#!/bin/bash


if (( $# != 4 )); then
    echo "Loads data from csv files to a postgres database"
    echo "USAGE:"
    echo "./load_files.sh DBNAME DBUSER TABLE_NAME FILES_DIRECTORY"
    exit 0
fi

DBNAME=$1
DBUSER=$2
TABLE_NAME=$3
FILES_DIRECTORY=$4

for f in $FILES_DIRECTORY/*.csv
do
    echo "Loading $f"
    psql $DBNAME -U $DBUSER -c "\\COPY $TABLE_NAME FROM $f WITH CSV DELIMITER ',' HEADER " 
done
