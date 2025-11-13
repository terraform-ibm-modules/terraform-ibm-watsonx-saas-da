terraform {
  required_version = ">= 1.9.0"
  # Lock DA into an exact provider version - renovate automation will keep it updated
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = "2.0.1"
    }
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.85.0"
    }
  }
}
