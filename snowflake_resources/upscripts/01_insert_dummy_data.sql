USE ROLE SYSADMIN;

UPDATE TEST_DB.TEST_SCHEMA.TEST_TABLE
SET COL3 = 0
WHERE COL1 IN (1,2);
