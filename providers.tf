provider "ibm" {
  alias            = "deployer"
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  visibility       = var.provider_visibility
}

provider "ibm" {
  alias            = "watsonx_admin"
  ibmcloud_api_key = var.watsonx_admin_api_key == null || var.watsonx_admin_api_key == "" ? var.ibmcloud_api_key : var.watsonx_admin_api_key
  region           = var.region
  visibility       = var.provider_visibility
}


provider "restapi" {
  alias                = "restapi_watsonx_admin"
  uri                  = "https:"
  write_returns_object = true
  debug                = false
  headers = {
    Authorization = data.ibm_iam_auth_token.restapi.iam_access_token
    Content-Type  = "application/json"
  }
}
