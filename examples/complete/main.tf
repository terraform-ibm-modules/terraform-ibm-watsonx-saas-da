module "watson_saas" {
  source                 = "../.."
  ibmcloud_api_key       = var.ibmcloud_api_key
  resource_prefix        = "example-complete-test"
  project_name           = "project-complete-test"
  watson_discovery_plan  = "plus"
  watson_assistant_plan  = "plus"
  watson_governance_plan = "standard-v2"
  location               = "eu-de"
}
