// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"log"
	"math/rand"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
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
			"location":            validRegions[rand.Intn(len(validRegions))],
			"resource_group_name": prefix,
			"cos_kms_crn":         permanentResources["hpcs_south_crn"],
			"cons_kms_key_crn":    permanentResources["hpcs_south_root_key_crn"],
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
