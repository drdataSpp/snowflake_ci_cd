# snowflake_ci_cd

## Setup

1. Run this SQLs in the Snowflake instances where you would like the deployments to happen snowflake_ci_cd\github_resources\snowflake_github_scripts.sql

2. Setup the required Github secrets:
    - TEST:
        - SNOWFLAKE_ACCOUNT_TEST
        - SNOWFLAKE_USER_TEST
        - SNOWFLAKE_PASSWORD_TEST
    - PROD:
        - SNOWFLAKE_ACCOUNT_PROD
        - SNOWFLAKE_USER_PROD
        - SNOWFLAKE_PASSWORD_PROD

3. Add the github workflow file to your repo snowflake_ci_cd\.github\workflows\deploy_pipeline.yml

## Testing Scenarios covered

| Testing Scenario | Type of Test | Result | PR link |
|----------|----------|----------|----------|
| Is the draft Github Workflow running and deploying objects to Snowflake (Single Instance)?| Functionality | PASS ✅ - GA was triggered on push trigger and SF objects were deployed | https://github.com/drdataSpp/snowflake_ci_cd/pull/4 |
| Is Github Actions getting triggered based on branch naming convention? | Functionality | PASS ✅ - Getting triggered when branch starts with 'DST-' | https://github.com/drdataSpp/snowflake_ci_cd/pull/8 |
| Is Github Actions deploying to test environment when GA is triggered baseon on branch name and to PROD when merged ? | Functionality | PASS ✅ - When merged the SF objects are deployed to PROD, during branch name based triggers it it getting deployed to TEST | https://github.com/drdataSpp/snowflake_ci_cd/pull/12 |

