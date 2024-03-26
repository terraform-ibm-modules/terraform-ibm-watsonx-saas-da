provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.location
}

provider "restapi" {
  uri                  = "https:"
  write_returns_object = true
  debug                = true
  headers = {
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
    Content-Type  = "application/json"
  }
  alias = "restapi_alias"
}
