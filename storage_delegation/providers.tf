provider "ibm" {
  ibmcloud_api_key = var.watsonx_admin_api_key
}

provider "restapi" {
  uri                  = "https:"
  write_returns_object = true
  debug                = true
  headers = {
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
    Content-Type  = "application/json"
  }
}
