locals {
  unique_identifier = random_string.unique_identifier.result
}

# Access random string generated with random_string.unique_identifier.result
resource "random_string" "unique_identifier" {
  length  = 6
  special = false
  upper   = false
}


module "watson_saas" {
  source                      = "../.."
  ibmcloud_api_key            = var.ibmcloud_api_key
  watsonx_admin_api_key       = var.watsonx_admin_api_key
  use_existing_resource_group = "false"
  resource_group_name         = local.unique_identifier
  resource_prefix             = "example-complete-test"
  project_name                = "project-complete-test"
  watson_discovery_plan       = "plus"
  watson_assistant_plan       = "plus"
  watson_governance_plan      = "essentials"
  location                    = "us-south"
}
