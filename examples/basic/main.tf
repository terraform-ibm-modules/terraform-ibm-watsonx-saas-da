module "watson_saas" {
  source           = "../.."
  ibmcloud_api_key = var.ibmcloud_api_key
  resource_prefix  = "example-basic-test"
  project_name     = "project-basic-test"
}
