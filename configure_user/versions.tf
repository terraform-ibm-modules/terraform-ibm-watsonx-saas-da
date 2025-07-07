terraform {
  required_version = ">= 1.5.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.79.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}
