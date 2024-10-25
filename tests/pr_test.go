// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"math/rand"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

// Use existing resource group
const rootDaDir = "./"

// Use existing resource group for test
const resourceGroup = "geretain-watsonx"

// Current supported regions
var validRegions = []string{
	"us-south",
	"eu-de",
}

func setupOptionsRootDA(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
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
	})

	terraformVars := map[string]interface{}{
		"location":            validRegions[rand.Intn(len(validRegions))],
		"resource_group_name": resourceGroup,
	}
	options.TerraformVars = terraformVars

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
