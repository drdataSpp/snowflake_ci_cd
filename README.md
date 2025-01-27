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

## GitHub Actions for Snowflake Deployments

This repository uses GitHub Actions to automate the deployment of Snowflake objects to both the TEST and PROD environments. Below is a brief overview of how the workflows operate and how you can use them effectively.

### Workflow Overview

#### TEST Environment

The TEST workflow is triggered by pull requests that modify files within the `snowflake_resources` directory. It performs the following steps:

1. **Checkout Repository**: The workflow checks out the repository to access the latest code changes.
2. **Set Snowflake Account**: It sets the Snowflake account credentials for the TEST environment using secrets stored in GitHub.
3. **Get List of Changed Files**: It identifies the SQL files that have changed in the pull request.
4. **Install Snowflake CLI**: If there are relevant changes, it installs the Snowflake CLI.
5. **Fetch Repository Changes in Snowflake**: It fetches the latest changes from the Snowflake repository.
6. **Execute Snowflake SQL Scripts**: It executes the changed SQL scripts in a specific order:
   - `snowflake_resources/backup_deletes`
   - `snowflake_resources/database`
   - `snowflake_resources/schema`
   - `snowflake_resources/table`
   - `snowflake_resources/view`
   - `snowflake_resources/upscripts`
7. **Post Deployment Status**: It posts a comment on the pull request with the deployment status and details of any errors.

#### PROD Environment

The PROD workflow is triggered by pull requests and pull request reviews that modify files within the `snowflake_resources` directory. It performs the following steps:

1. **Check Approvals**: The workflow checks if the pull request has at least one approval.
2. **Check Changes**: It identifies if there are changes in the `snowflake_resources` directory.
3. **Deploy to PROD**: If the pull request is approved and there are relevant changes, it performs the deployment to the PROD environment, similar to the TEST workflow.

### How to Use

1. **Create or Update SQL Files**: Make changes to SQL files within the `snowflake_resources` directory.
2. **Open a Pull Request**: Open a pull request to merge your changes. The TEST workflow will automatically run and deploy the changes to the TEST environment.
3. **Review and Approve**: Once the changes are reviewed and approved, the PROD workflow will automatically run and deploy the changes to the PROD environment.
4. **Check Deployment Status**: The workflows will post comments on the pull request with the deployment status, including any successfully deployed files and any errors encountered.

### Important Notes

- **Branch Naming**: The TEST workflow skips deployment for branches starting with `snowflake-manual-deployment-`.
- **Secrets Management**: Ensure that the necessary secrets (`SNOWFLAKE_ACCOUNT_TEST`, `SNOWFLAKE_USER_TEST`, `SNOWFLAKE_PASSWORD_TEST`, `SNOWFLAKE_ACCOUNT_PROD`, `SNOWFLAKE_USER_PROD`, `SNOWFLAKE_PASSWORD_PROD`) are configured in the repository settings.
- **Execution Order**: SQL scripts are executed in a predefined order to ensure dependencies are respected.

### Moving a Snowflake SQL Script from Feature Branch to Production

1. **Feature Branch**: Create or update SQL files in your feature branch within the `snowflake_resources` directory.
2. **Pull Request**: Open a pull request to merge your feature branch into the main branch. The TEST workflow will run automatically.
3. **Testing**: Verify the deployment in the TEST environment. The workflow will post a comment on the pull request with the deployment status.
4. **Approval**: Once the changes are reviewed and approved, the PROD workflow will run automatically.
5. **Production Deployment**: The PROD workflow will deploy the changes to the PROD environment and post a comment on the pull request with the deployment status.

By following these steps, you can streamline your Snowflake deployments and ensure a smooth workflow from development to production.

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
