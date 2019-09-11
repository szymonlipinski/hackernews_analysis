BEGIN;

CREATE INDEX i_raw_data_object_id ON raw_data (object_id);

CREATE TABLE data AS 
SELECT DISTINCT ON (object_id) *
FROM raw_data;

DROP TABLE raw_data;

COMMIT;
