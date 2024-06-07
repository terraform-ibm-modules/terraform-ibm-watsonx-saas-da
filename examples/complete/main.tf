locals {
  unique_identifier = random_string.unique_identifier.result
}

# Access random string generated with random_string.unique_identifier.result
resource "random_string" "unique_identifier" {
  length  = 6
  special = false
  upper   = false
}


module "watsonx_saas" {
  source                      = "../.."
  ibmcloud_api_key            = var.ibmcloud_api_key
  watsonx_admin_api_key       = var.watsonx_admin_api_key
  use_existing_resource_group = "false"
  resource_group_name         = local.unique_identifier
  resource_prefix             = "example-complete-test"
  watsonx_project_name        = "project-complete-test"
  watson_discovery_plan       = "plus"
  watsonx_assistant_plan      = "plus"
  watsonx_governance_plan     = "essentials"
  location                    = "us-south"
  cos_kms_crn                 = "crn:v1:bluemix:public:kms:us-south:a/0e550c0a99db49b1813ffb36fadec76b:85cee4b9-5cd2-423c-ba7f-22e89e96c7d3::"
  cos_kms_new_key_name        = "testCompleteExample"
}
