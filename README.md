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

## How does the Github Actions work?
- DEVs create a feature branch and add their SQL files under the `snowflake_resources` folder.
- When a PR is created, the `Deploy Snowflake Objects to TEST Environment` GitHub action run as it gets triggered by one of the following PR states: opened, reopened, ready_for_review, synchronize.
    - The `Deploy Snowflake Objects to TEST Environment` GitHub action deploys the new and/or updated SQL scripts to Snowflake Test Instance.
- When the PR gets at least one approval (tick), the `Deploy Snowflake Objects to PROD Environment` GitHub action deploys the new and/or updated SQL scripts to Snowflake PROD Instance.
- Both runs adds comments to the PR converstation section, based on the output, we can merge the PR to master/ main branch.

## Testing Scenarios Covered

| Testing Scenario | Type of Test | Result | PR Link |
|------------------|--------------|--------|---------|
| **Is the draft GitHub Workflow running and deploying objects to Snowflake (Single Instance)?** | Functionality | PASS ✅ - GitHub Actions (GA) was triggered on push, and Snowflake (SF) objects were deployed in the correct order | [PR Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/4) |
| **Are GitHub Actions triggered based on branch naming conventions?** | Functionality | PASS ✅ - Triggered when the branch name starts with 'DST-' | [PR Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/8) |
| **Is GitHub Actions deploying to the test environment when GA is triggered based on branch name, and to PROD when merged?** | Functionality | PASS ✅ - When merged, SF objects are deployed to PROD; during branch name-based triggers, they are deployed to TEST | [PR Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/12) |
| **Is GitHub Actions printing the deployment status to PR during TEST and skipping prints when deploying to PROD?** | Functionality & Logging | PASS ✅ - For TEST deployment, both success and failure messages are printed to the PR; for PROD, the print step is skipped | [PR Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/15) |
| **Can we push files to the repo that touch the Snowflake directory and skip the GitHub action from running?** | Functionality | FAIL ❌ - When PR is created, TEST deployment is skipped; when PR is merged, PROD deployment runs | [PR Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/18) and [PR Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/19) |
| **Was a branch protection rule added, and was the logic updated to deploy to PROD when there’s at least one approval tick?** | Functionality | PASS ✅ - When a PR is created, the TEST deployment is triggered; when the PR receives one approval tick, the PROD deployment is triggered. | [PR Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/52) |
| **How do GitHub Actions behave when there are no changes in the `snowflake_resources` folder?** | Functionality | PASS ✅ - GitHub Actions correctly detect that no Snowflake-related SQL files were modified, and the Snowflake deploy step is skipped. | [PR Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/54) |
| **How do GitHub Actions behave when a PR is reverted?** | Functionality | PASS ✅ - GitHub Actions successfully deploy the original version of the SQL script to TEST, and to PROD when the PR receives one approval tick. | [PR Link](https://github.com/drdataSpp/snowflake_ci_cd/pull/55) |
