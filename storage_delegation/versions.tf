terraform {
  required_version = ">= 1.5.0"
  required_providers {
    restapi = {
      source                = "Mastercard/restapi"
      version               = ">= 1.19.1"
      configuration_aliases = [restapi.restapi_watsonx_admin]
    }
    ibm = {
      source                = "IBM-Cloud/ibm"
      version               = ">= 1.79.2"
      configuration_aliases = [ibm.deployer]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.12.0"
    }
  }
}
