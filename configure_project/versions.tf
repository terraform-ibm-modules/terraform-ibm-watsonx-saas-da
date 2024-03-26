terraform {
  required_version = ">= 1.5.0"
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 1.19.1"
    }
  }
}
