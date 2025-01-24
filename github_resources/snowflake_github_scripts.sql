/*

PURPOSE: 

* This below SQLs will create a DB and create a GIT object in Snowflake and it's dependencies like external integration.
* Typically an Organization will be having more than one Snowflake Account, one for PROD and one for NON-PROD, the below SQLs should be ran in all the SF accounts where you want the Snowflake SQLs should be deployed. 

*/


--===================================================================================
-- Step1. Create a database and schema to store GITHUB REPO Snowflake Object
--===================================================================================

USE ROLE SYSADMIN;

CREATE TRANSIENT DATABASE IF NOT EXISTS GITHUB
DATA_RETENTION_TIME_IN_DAYS = 0;

CREATE SCHEMA IF NOT EXISTS GITHUB.SNOWFLAKE_GIT;
USE SCHEMA GITHUB.SNOWFLAKE_GIT;

--===================================================================================
-- Step2. Create GitHub Access Secret
--===================================================================================

CREATE OR REPLACE SECRET GITHUB.SNOWFLAKE_GIT.SNOWFLAKE_GIT_SECRET
TYPE = password
  USERNAME = '<github_user_name>'
  PASSWORD = '<github_PAT_token>'
;

--===================================================================================
-- Step3. Create an external integration
--===================================================================================

USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com')
  ALLOWED_AUTHENTICATION_SECRETS = (GITHUB.SNOWFLAKE_GIT.SNOWFLAKE_GIT_SECRET)
  ENABLED = TRUE;

--===================================================================================
-- Step4. Create the GitHub Snowflake Object
--===================================================================================

USE ROLE SYSADMIN;

CREATE OR REPLACE GIT REPOSITORY GITHUB.SNOWFLAKE_GIT.SNOWFLAKE_REPO
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/drdataSpp/snowflake_ci_cd.git'
  ;

--===================================================================================
-- Step5. Create a dedicated warehouse for deployments.
--===================================================================================

USE ROLE SYSADMIN;

CREATE WAREHOUSE devops_wh
WITH 
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'Warehouse for deploying Github Snowflake scripts.';

--===================================================================================
-- Step6. Create a service user for DEVOPS purposes.
--===================================================================================

USE ROLE USERADMIN;

CREATE USER devops_sa
    PASSWORD = ''
    DEFAULT_ROLE = SYSADMIN /* Ideally we should have a dedicated role */
    DEFAULT_WAREHOUSE = DEVOPS_WH
    COMMENT = 'Service account for Github Actions.';

--===================================================================================
-- Step7. Verify that SYSAMIN role can fetch GIT Object in Snowflake.
--===================================================================================

USE ROLE SYSADMIN;

/* Fetch the changes from the repo */
ALTER GIT REPOSITORY GITHUB.SNOWFLAKE_GIT.SNOWFLAKE_REPO FETCH;

/* List the files in the repo */

LS @GITHUB.SNOWFLAKE_GIT.SNOWFLAKE_REPO/branches/master; /* main or master branch */