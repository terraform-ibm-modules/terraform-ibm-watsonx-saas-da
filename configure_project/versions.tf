terraform {
  required_version = ">= 1.9.0"
  required_providers {
    restapi = {
      source                = "Mastercard/restapi"
      version               = ">= 2.0.1, <3.0.0"
      configuration_aliases = [restapi.restapi_watsonx_admin]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.12.1, <1.0.0"
    }
  }
}
