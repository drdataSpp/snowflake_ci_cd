# snowflake_ci_cd

## Setup

1. Run the SQL scripts in the Snowflake instances where you would like the deployments to happen: `snowflake_ci_cd\github_resources\snowflake_github_scripts.sql`.

2. Set up the required GitHub secrets:
    - **TEST:**
        - `SNOWFLAKE_ACCOUNT_TEST`
        - `SNOWFLAKE_USER_TEST`
        - `SNOWFLAKE_PASSWORD_TEST`
    - **PROD:**
        - `SNOWFLAKE_ACCOUNT_PROD`
        - `SNOWFLAKE_USER_PROD`
        - `SNOWFLAKE_PASSWORD_PROD`

3. Add the GitHub workflow file to your repository: `snowflake_ci_cd\.github\workflows\deploy_pipeline.yml`.

## Testing Scenarios Covered

| Testing Scenario | Type of Test | Result | PR Link |
|------------------|--------------|--------|---------|
| Is the draft GitHub Workflow running and deploying objects to Snowflake (Single Instance)? | Functionality | PASS ✅ - GA was triggered on push, and SF objects were deployed in the correct order | [Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/4) |
| Are GitHub Actions getting triggered based on branch naming conventions? | Functionality | PASS ✅ - Triggered when branch starts with 'DST-' | [Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/8) |
| Is GitHub Actions deploying to the test environment when GA is triggered based on branch name, and to PROD when merged? | Functionality | PASS ✅ - When merged, SF objects are deployed to PROD; during branch name-based triggers, it deploys to TEST | [Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/12) |
| Is GitHub Actions printing the deployment status to PR during TEST and skipping prints when deploying to PROD? | Functionality & Logging | PASS ✅ - For TEST deployment, both pass and failure messages are printed to the PR; for PROD, the print step is skipped | [Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/15) |
| Can we push files to the repo that touch the Snowflake directory and skip the GitHub action from running? | Functionality | FAIL ❌ - When PR is created, TEST deployment is skipped; when PR is merged, PROD deployment runs | [Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/18) and [Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/19) |
| Branch protection rule added and updated the logic to deploy to PROD when there's at least 1 tick | Functionality | PASS ✅ - When PR is created, TEST deployment is done; when PR gets one tick, PROD deployment is done | [Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/25) |
