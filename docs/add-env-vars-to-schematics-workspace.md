# How to add environment variables to a Deployable Architecture workspace

When you deploy a Deployable Architecture (DA) from the IBM Cloud catalog, a Schematics workspace is created to manage the Terraform execution. In some cases, you may need to add environment variables to this workspace to enable specific features or configurations.

This guide walks you through the steps to add environment variables to your DA workspace.

## Prerequisites

- [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-getting-started) installed
- [Schematics plugin](https://cloud.ibm.com/docs/schematics?topic=schematics-setup-cli) installed (`ibmcloud plugin install schematics`)
- You are logged in to IBM Cloud (`ibmcloud login`)

## Step 1: Find your workspace ID

After deploying a DA, a Schematics workspace is created. To find the workspace ID:

### Option A: Using the CLI

```bash
ibmcloud schematics workspace list
```

Look for your workspace in the output. The workspace ID is in the format `us-south.workspace.<name>.<id>`.

### Option B: Using the IBM Cloud console

1. Go to [Schematics workspaces](https://cloud.ibm.com/schematics/workspaces)
2. Find your workspace in the list
3. Click on the workspace to open it
4. The workspace ID is displayed in the details panel and in the URL

## Step 2: Create the environment variable update file

Create a JSON file with the environment variables you want to add. Replace `<your-workspace-name>` with your actual workspace name and add the environment variables you need.

```bash
cat > /tmp/env-update.json << 'EOF'
{
  "name": "<your-workspace-name>",
  "template_data": [{
    "env_values": [
      {"<ENV_VAR_NAME>": "<value>"}
    ]
  }]
}
EOF
```

### Example: Adding multiple environment variables

```bash
cat > /tmp/env-update.json << 'EOF'
{
  "name": "my-da-workspace",
  "template_data": [{
    "env_values": [
      {"API_DATA_IS_SENSITIVE": "true"},
      {"TF_LOG": "INFO"}
    ]
  }]
}
EOF
```

## Step 3: Update the workspace

Run the following command to apply the environment variables to your workspace:

```bash
ibmcloud schematics workspace update --id <workspace-id> --file /tmp/env-update.json
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
{"API_DATA_IS_SENSITIVE": "true"}
```

### __netrc__

**When to use:** DAs that need to pull Terraform modules from private or authenticated Git repositories.

**Purpose:** Provides Git credentials for accessing private repositories during `terraform init`.

```json
{"__netrc__": "github.com <username> <personal-access-token>"}
```

For more information, see [Using private modules in Schematics](https://cloud.ibm.com/docs/schematics?topic=schematics-download-modules-pvt-git).

### TF_LOG

**When to use:** When you need to debug Terraform execution issues.

**Purpose:** Enables detailed Terraform logging.

```json
{"TF_LOG": "DEBUG"}
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
