terraform {
  required_version = ">= 1.9.0"
  required_providers {
    ibm = {
      source                = "IBM-Cloud/ibm"
      version               = ">= 1.80.0, <3.0.0"
      configuration_aliases = [ibm.deployer]
    }
  }
}
