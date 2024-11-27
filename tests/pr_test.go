// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"fmt"
	"log"
	"math/rand"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

// Use existing resource group
const rootDaDir = "./"

// Current supported regions
var validRegions = []string{
	"us-south",
	"eu-de",
}

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var permanentResources map[string]interface{}

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {

	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptionsRootDA(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		Prefix:       prefix,
		IgnoreDestroys: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				"module.configure_user.null_resource.configure_user",
				"module.configure_user.null_resource.restrict_access",
			},
		},
		IgnoreUpdates: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				"module.configure_user.null_resource.configure_user",
				"module.configure_user.null_resource.restrict_access",
			},
		},
		TerraformVars: map[string]interface{}{
			"location":                  validRegions[rand.Intn(len(validRegions))],
			"resource_group_name":       prefix,
			"enable_cos_kms_encryption": false,
		},
	})

	return options
}

func TestRunRootDA(t *testing.T) {
	t.Parallel()

	options := setupOptionsRootDA(t, "watsonx-da", rootDaDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeRootDA(t *testing.T) {
	t.Parallel()

	options := setupOptionsRootDA(t, "watsonx-da-upg", rootDaDir)

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func TestWithExistingKP(t *testing.T) {
	t.Parallel()

	// ------------------------------------------------------------------------------------
	// Provision KP first
	// ------------------------------------------------------------------------------------

	prefix := fmt.Sprintf("kp-t-%s", strings.ToLower(random.UniqueId()))
	realTerraformDir := "./resources/kp-instance"
	tempTerraformDir, _ := files.CopyTerraformFolderToTemp(realTerraformDir, fmt.Sprintf(prefix+"-%s", strings.ToLower(random.UniqueId())))
	region := "us-south"

	// Verify ibmcloud_api_key variable is set
	checkVariable := "TF_VAR_ibmcloud_api_key"
	val, present := os.LookupEnv(checkVariable)
	require.True(t, present, checkVariable+" environment variable not set")
	require.NotEqual(t, "", val, checkVariable+" environment variable is empty")

	logger.Log(t, "Tempdir: ", tempTerraformDir)
	existingTerraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: tempTerraformDir,
		Vars: map[string]interface{}{
			"prefix": prefix,
			"region": region,
		},
		// Set Upgrade to true to ensure latest version of providers and modules are used by terratest.
		// This is the same as setting the -upgrade=true flag with terraform.
		Upgrade: true,
	})

	terraform.WorkspaceSelectOrNew(t, existingTerraformOptions, prefix)
	_, existErr := terraform.InitAndApplyE(t, existingTerraformOptions)
	if existErr != nil {
		assert.True(t, existErr == nil, "Init and Apply of temp existing resource failed")
	} else {

		// ------------------------------------------------------------------------------------
		// Deploy watsonx DA passing in existing KP details
		// ------------------------------------------------------------------------------------

		options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
			Testing:      t,
			TerraformDir: rootDaDir,
			Prefix:       "existing-kp",
			IgnoreDestroys: testhelper.Exemptions{ // Ignore for consistency check
				List: []string{
					"module.configure_user.null_resource.configure_user",
					"module.configure_user.null_resource.restrict_access",
				},
			},
			IgnoreUpdates: testhelper.Exemptions{ // Ignore for consistency check
				List: []string{
					"module.configure_user.null_resource.configure_user",
					"module.configure_user.null_resource.restrict_access",
				},
			},
			TerraformVars: map[string]interface{}{
				"location":            validRegions[rand.Intn(len(validRegions))],
				"resource_group_name": prefix,
				"cos_kms_crn":         terraform.Output(t, existingTerraformOptions, "key_protect_crn"),
				"cos_kms_key_crn":     terraform.Output(t, existingTerraformOptions, "kms_key_crn"),
			},
		})

		output, err := options.RunTestConsistency()
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}

	// Check if "DO_NOT_DESTROY_ON_FAILURE" is set
	envVal, _ := os.LookupEnv("DO_NOT_DESTROY_ON_FAILURE")
	// Destroy the temporary existing resources if required
	if t.Failed() && strings.ToLower(envVal) == "true" {
		fmt.Println("Terratest failed. Debug the test and delete resources manually.")
	} else {
		logger.Log(t, "START: Destroy (existing resources)")
		terraform.Destroy(t, existingTerraformOptions)
		terraform.WorkspaceDelete(t, existingTerraformOptions, prefix)
		logger.Log(t, "END: Destroy (existing resources)")
	}

}
