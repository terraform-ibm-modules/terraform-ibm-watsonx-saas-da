terraform {
  required_version = ">= 1.5.0"
  required_providers {
    restapi = {
      source                = "Mastercard/restapi"
      version               = ">= 1.19.1"
      configuration_aliases = [restapi.restapi_watsonx_admin]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.11.2"
    }
  }
}
