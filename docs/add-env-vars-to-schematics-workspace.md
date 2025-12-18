# How to add environment variables to a Deployable Architecture workspace

When you deploy a Deployable Architecture (DA) from the IBM Cloud catalog, a Schematics workspace is created to manage the Terraform execution. In some cases, you may need to add environment variables to this workspace to enable specific features or configurations.

This guide walks you through the steps to add environment variables to your DA workspace.

## Prerequisites

- [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-getting-started) installed
- [Schematics plugin](https://cloud.ibm.com/docs/schematics?topic=schematics-setup-cli) installed (`ibmcloud plugin install schematics`)
- You are logged in to IBM Cloud (`ibmcloud login`)

## Step 1: Find your workspace ID and template ID

After deploying a DA, a Schematics workspace is created. To find the workspace ID and template ID:

### Option A: Using Projects (recommended for DA deployments)

If you deployed your DA through a Project, follow these steps:

1. Go to [Projects](https://cloud.ibm.com/projects) in the IBM Cloud console
2. Select the project that contains your DA deployment
3. Click on the **Configurations** tab
4. Find your DA configuration and click on it
5. In the configuration details, look for the **Workspace** link under the deployment information
6. Click the workspace link to open it in Schematics
7. The workspace ID is displayed in the details panel (format: `us-south.workspace.<name>.<id>`)
8. The template ID is shown in the **Templates** section of the workspace

### Option B: Using the CLI

If you know your workspace name, you can find it via CLI:

```bash
ibmcloud schematics workspace list
```

Look for your workspace in the output. Once you have the workspace ID, get the template ID:

```bash
ibmcloud schematics workspace get --id <workspace-id> --output json | jq -r '.template_data[0].id'
```

## Step 2: Create the environment variable update file

Create a JSON file with the environment variables you want to add:

```bash
cat > /tmp/env-update.json << 'EOF'
{
  "env_values": [
    {
      "name": "<ENV_VAR_NAME>",
      "value": "<value>",
      "secure": false,
      "hidden": false
    }
  ]
}
EOF
```

### Example: Adding multiple environment variables

```bash
cat > /tmp/env-update.json << 'EOF'
{
  "env_values": [
    {
      "name": "API_DATA_IS_SENSITIVE",
      "value": "true",
      "secure": false,
      "hidden": false
    },
    {
      "name": "TF_LOG",
      "value": "INFO",
      "secure": false,
      "hidden": false
    }
  ]
}
EOF
```

## Step 3: Update the workspace variables

Run the following command to apply the environment variables to your workspace:

```bash
ibmcloud schematics workspace update-variables \
  --id <workspace-id> \
  --template <template-id> \
  --file /tmp/env-update.json
```

## Step 4: Verify the update

Confirm the environment variables were added successfully:

```bash
ibmcloud schematics workspace get --id <workspace-id> --output json | jq '.template_data[0].env_values'
```

You should see output similar to:

```json
[
  {
    "name": "API_DATA_IS_SENSITIVE",
    "value": "true",
    "secure": false,
    "hidden": false
  }
]
```

## Common environment variables

### API_DATA_IS_SENSITIVE

**When to use:** DAs that use the [Mastercard/restapi](https://registry.terraform.io/providers/Mastercard/restapi/latest) Terraform provider.

**Purpose:** Prevents sensitive data (API keys, credentials) from being displayed in Terraform plan/apply output and Schematics logs.

```json
{
  "name": "API_DATA_IS_SENSITIVE",
  "value": "true",
  "secure": false,
  "hidden": false
}
```

### __netrc__

**When to use:** DAs that need to pull Terraform modules from private or authenticated Git repositories.

**Purpose:** Provides Git credentials for accessing private repositories during `terraform init`.

```json
{
  "name": "__netrc__",
  "value": "github.com <username> <personal-access-token>",
  "secure": true,
  "hidden": true
}
```

For more information, see [Using private modules in Schematics](https://cloud.ibm.com/docs/schematics?topic=schematics-download-modules-pvt-git).

### TF_LOG

**When to use:** When you need to debug Terraform execution issues.

**Purpose:** Enables detailed Terraform logging.

```json
{
  "name": "TF_LOG",
  "value": "DEBUG",
  "secure": false,
  "hidden": false
}
```

Valid values: `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`

## Troubleshooting

### Environment variable not taking effect

After updating the workspace, you need to run a new plan/apply for the environment variables to take effect. The changes won't apply to already-running jobs.

### Workspace is locked

If you get an error that the workspace is locked, wait for any running jobs to complete before updating:

```bash
ibmcloud schematics workspace get --id <workspace-id> --output json | jq '.workspace_status'
```

## Additional resources

- [Using environment variables with workspaces](https://cloud.ibm.com/docs/schematics?topic=schematics-set-parallelism)
- [Schematics CLI reference](https://cloud.ibm.com/docs/schematics?topic=schematics-schematics-cli-reference)
