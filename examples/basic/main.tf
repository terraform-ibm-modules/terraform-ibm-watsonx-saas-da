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
  resource_prefix             = "example-basic-test"
  use_existing_resource_group = "false"
  resource_group_name         = local.unique_identifier
  watsonx_project_name        = "project-basic-test"
}
