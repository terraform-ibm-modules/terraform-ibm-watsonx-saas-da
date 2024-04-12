// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"os"
	"testing"
)

// Use existing resource group
const basicExampleDir = "examples/basic"
const completeExampleDir = "examples/complete"

func setupOptionsBasicExample(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		IgnoreDestroys: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				"module.watson_saas.module.configure_user.null_resource.configure_user",
				"module.watson_saas.module.configure_user.null_resource.restrict_access",
			},
		},
		IgnoreUpdates: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				"module.watson_saas.module.configure_user.null_resource.configure_user",
				"module.watson_saas.module.configure_user.null_resource.restrict_access",
			},
		},
	})
	return options
}

func setupOptionsCompleteExample(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	apiKey := os.Getenv("TF_VAR_watsonx_admin_api_key")
	require.NotEmpty(t, apiKey, "TF_VAR_watsonx_admin_api_key environment variable is not set")
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		IgnoreDestroys: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				"module.watson_saas.module.configure_user.null_resource.configure_user",
				"module.watson_saas.module.configure_user.null_resource.restrict_access",
			},
		},
		IgnoreUpdates: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				"module.watson_saas.module.configure_user.null_resource.configure_user",
				"module.watson_saas.module.configure_user.null_resource.restrict_access",
			},
		},
		TerraformVars: map[string]interface{}{
			"watsonx_admin_api_key": apiKey, // pragma: allowlist secret
		},
	})
	return options
}

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsBasicExample(t, "watsonx-basic", basicExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunCompleteExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsCompleteExample(t, "watsonx-complete", completeExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
