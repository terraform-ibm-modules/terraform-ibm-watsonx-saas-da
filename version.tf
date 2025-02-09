terraform {
  required_version = ">= 1.5.0"
  # Lock DA into an exact provider version - renovate automation will keep it updated
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = "1.20.0"
    }
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.75.1"
    }
  }
}
