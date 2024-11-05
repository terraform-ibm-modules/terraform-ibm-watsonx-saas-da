provider "ibm" {
  alias            = "deployer"
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.location
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.location
}
