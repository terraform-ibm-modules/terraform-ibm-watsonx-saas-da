locals {
  unique_identifier = random_string.unique_identifier.result
}

# Access random string generated with random_string.unique_identifier.result
resource "random_string" "unique_identifier" {
  length  = 6
  special = false
  upper   = false
}

data "ibm_resource_group" "group" {
  is_default = "true"
}

module "kms" {
  source                    = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                   = "4.16.8"
  resource_group_id         = data.ibm_resource_group.group.id
  region                    = var.location
  key_protect_instance_name = "watsonx-kp"
}


module "watsonx_saas" {
  source                      = "../.."
  ibmcloud_api_key            = var.ibmcloud_api_key
  watsonx_admin_api_key       = var.watsonx_admin_api_key
  use_existing_resource_group = "false"
  resource_group_name         = local.unique_identifier
  resource_prefix             = "complete-test-${local.unique_identifier}"
  watsonx_project_name        = "project-complete-test"
  watson_discovery_plan       = "plus"
  watsonx_assistant_plan      = "plus"
  watsonx_governance_plan     = "essentials"
  watsonx_data_plan           = "lakehouse-enterprise"
  location                    = var.location
  cos_kms_crn                 = module.kms.key_protect_crn
  cos_kms_new_key_name        = "testCompleteExample"
}
