// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"fmt"
	"log"
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
	"eu-gb",
	"jp-tok",
	"au-syd",
	"ca-tor",
}

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var permanentResources map[string]interface{}

// required for Rest API provider 2.x. Alternatively, need to add `ignore_all_server_changes=true` in restapi_object resources.
var IgnoreUpdates = []string{
	"module.storage_delegation[0].restapi_object.storage_delegation",
	"module.configure_project[0].restapi_object.configure_project",
}

// Both below resources will always bs re-created due to the always_run trigger
var IgnoreDestroys = []string{
	"module.configure_user.null_resource.configure_user",
	"module.configure_user.null_resource.restrict_access",
}

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
		IgnoreDestroys: testhelper.Exemptions{
			List: IgnoreDestroys,
		},
		IgnoreUpdates: testhelper.Exemptions{
			List: IgnoreUpdates,
		},
	})

	options.TerraformVars = map[string]interface{}{
		"region":              validRegions[common.CryptoIntn(len(validRegions))],
		"provider_visibility": "public",
		"prefix":              options.Prefix,
	}

	return options
}

// Provision KMS - Key Protect to use in DA tests
func setupKMSKeyProtect(t *testing.T, region string, prefix string) *terraform.Options {
	realTerraformDir := "./resources/kp-cos-instance"
	tempTerraformDir, _ := files.CopyTerraformFolderToTemp(realTerraformDir, fmt.Sprintf(prefix+"-%s", strings.ToLower(random.UniqueId())))

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
	require.NoError(t, existErr, "Init and Apply of temp resources (KP Instance and Key creation) failed")

	return existingTerraformOptions
}

// Cleanup the resources when KMS encryption key is created.
func cleanupResources(t *testing.T, terraformOptions *terraform.Options, prefix string) {
	// Check if "DO_NOT_DESTROY_ON_FAILURE" is set
	envVal, _ := os.LookupEnv("DO_NOT_DESTROY_ON_FAILURE")
	// Destroy the temporary existing resources if required
	if t.Failed() && strings.ToLower(envVal) == "true" {
		fmt.Println("Terratest failed. Debug the test and delete resources manually.")
	} else {
		logger.Log(t, "START: Destroy (existing resources)")
		terraform.Destroy(t, terraformOptions)
		terraform.WorkspaceDelete(t, terraformOptions, prefix)
		logger.Log(t, "END: Destroy (existing resources)")
	}
}

func TestRunRootDA(t *testing.T) {
	t.Parallel()

	options := setupOptionsRootDA(t, "wx-da", rootDaDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeRootDA(t *testing.T) {
	t.Parallel()

	options := setupOptionsRootDA(t, "wx-da-upg", rootDaDir)

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func TestWithExistingKPKey(t *testing.T) {
	t.Parallel()

	region := validRegions[common.CryptoIntn(len(validRegions))]
	prefix := fmt.Sprintf("kp-wx-%s", strings.ToLower(random.UniqueId()))

	// Provision Existing KMS instance
	existingTerraformOptions := setupKMSKeyProtect(t, region, prefix)

	// Deploy watsonx DA using existing KP details
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: rootDaDir,
		IgnoreDestroys: testhelper.Exemptions{
			List: IgnoreDestroys,
		},
		IgnoreUpdates: testhelper.Exemptions{
			List: IgnoreUpdates,
		},
	})

	options.TerraformVars = map[string]interface{}{
		"region":                    region,
		"provider_visibility":       "public",
		"enable_cos_kms_encryption": true,
		"cos_kms_crn":               terraform.Output(t, existingTerraformOptions, "key_protect_crn"),
		"cos_kms_key_crn":           terraform.Output(t, existingTerraformOptions, "kms_key_crn"),
		"existing_cos_instance_crn": terraform.Output(t, existingTerraformOptions, "cos_crn"),
		"prefix":                    prefix,
	}

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")

	cleanupResources(t, existingTerraformOptions, prefix)
}

func TestWithExistingKP(t *testing.T) {
	t.Parallel()

	region := validRegions[common.CryptoIntn(len(validRegions))]
	prefix := fmt.Sprintf("kp-wx-%s", strings.ToLower(random.UniqueId()))

	// Provision Existing KMS instance
	existingTerraformOptions := setupKMSKeyProtect(t, region, prefix)

	// Deploy watsonx DA using existing KP details
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: rootDaDir,
		IgnoreDestroys: testhelper.Exemptions{
			List: IgnoreDestroys,
		},
		IgnoreUpdates: testhelper.Exemptions{
			List: IgnoreUpdates,
		},
	})

	options.TerraformVars = map[string]interface{}{
		"region":                    region,
		"provider_visibility":       "public",
		"enable_cos_kms_encryption": true,
		"cos_kms_crn":               terraform.Output(t, existingTerraformOptions, "key_protect_crn"),
		"existing_cos_instance_crn": terraform.Output(t, existingTerraformOptions, "cos_crn"),
		"prefix":                    prefix,
	}

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")

	cleanupResources(t, existingTerraformOptions, prefix)
}

func TestRunUpgradeExistingKPNewKey(t *testing.T) {
	t.Parallel()

	region := validRegions[common.CryptoIntn(len(validRegions))]
	prefix := fmt.Sprintf("kp-t-%s", strings.ToLower(random.UniqueId()))

	// Provision Existing KMS instance
	existingTerraformOptions := setupKMSKeyProtect(t, region, prefix)

	// Deploy watsonx DA using existing KP details
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: rootDaDir,
		Prefix:       "existing-kp-upg",
		IgnoreDestroys: testhelper.Exemptions{
			List: IgnoreDestroys,
		},
		IgnoreUpdates: testhelper.Exemptions{
			List: IgnoreUpdates,
		},
	})
	options.TerraformVars = map[string]interface{}{
		"region":                    region,
		"prefix":                    prefix,
		"provider_visibility":       "public",
		"enable_cos_kms_encryption": true,
		"cos_kms_crn":               terraform.Output(t, existingTerraformOptions, "key_protect_crn"),
		"cos_kms_key_crn":           terraform.Output(t, existingTerraformOptions, "kms_key_crn"),
		"existing_cos_instance_crn": terraform.Output(t, existingTerraformOptions, "cos_crn"),
	}

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}

	cleanupResources(t, existingTerraformOptions, prefix)
}
