variable "ibmcloud_api_key" {
  description = "Used with the Terraform IBM-Cloud/ibm provider"
  sensitive   = true
  type        = string
}

variable "location" {
  default     = "us-south"
  description = "Used with the Terraform IBM-Cloud/ibm provider as well as resource creation."
  type        = string
  validation {
    condition     = contains(["au-syd", "br-sao", "ca-tor", "eu-de", "eu-gb", "jp-osa", "jp-tok", "us-east", "us-south"], var.location)
    error_message = "The IBM Cloud location to use must be one of: au-syd, br-sao, ca-tor, eu-de, eu-gb, jp-osa, jp-tok, us-east, or us-south"
  }
}

variable "resource_group_name" {
  default     = null
  description = "Name of the IBM Cloud resource group in which resources should be created"
  type        = string
}

variable "resource_prefix" {
  description = "Name to be used on all Watson resource as prefix"
  type        = string
  default     = "watsonx-poc"

  validation {
    condition     = var.resource_prefix != "" && length(var.resource_prefix) <= 25
    error_message = "Sorry, please provide value for resource_prefix variable or check the length of resource_prefix it should be less than 25 chars."
  }
}

variable "cos_plan" {
  default     = "standard"
  description = "Resource plan used to provision the Cloud Object Storage instance."
  type        = string
  validation {
    condition     = contains(["standard"], var.cos_plan)
    error_message = "The plan to use must be standard"
  }
}

variable "watson_machine_learning_plan" {
  default     = "lite"
  description = "Resource plan used to provision the Watson Machine Learning instance."
  type        = string
  validation {
    condition     = contains(["lite", "professional", "v2-professional", "v2-standard"], var.watson_machine_learning_plan)
    error_message = "The plan to use must be one of: lite, professional, v2-professional or v2-standard"
  }
}

variable "watson_studio_plan" {
  default     = "free-v1"
  description = "Resource plan used to provision the Watson Studio instance."
  type        = string
  validation {
    condition     = contains(["free-v1", "professional-v1", "standard-v1", "sqo-enterprise-v2", "enterprise-v2"], var.watson_studio_plan)
    error_message = "The plan to use must be one of: free-v1, professional-v1, standard-v1, sqo-enterprise-v2 or enterprise-v2"
  }
}

variable "watson_discovery_plan" {
  default     = "do not install"
  description = "Resource plan used to provision the Watson Discovery instance."
  type        = string
  validation {
    condition = anytrue([
      var.watson_discovery_plan == "do not install",
      var.watson_discovery_plan == "plus",
      var.watson_discovery_plan == "enterprise",
      var.watson_discovery_plan == "premium",
    ])
    error_message = "The plan to use must be one of: plus, enterprise or premium"
  }
}

variable "watson_assistant_plan" {
  default     = "do not install"
  description = "Resource plan used to provision the watsonx Assistance instance."
  type        = string
  validation {
    condition = anytrue([
      var.watson_assistant_plan == "do not install",
      var.watson_assistant_plan == "free",
      var.watson_assistant_plan == "plus-trial",
      var.watson_assistant_plan == "plus",
      var.watson_assistant_plan == "enterprise",
    ])
    error_message = "The plan to use must be one of: free, trial, plus-trial or enterprise"
  }
}

variable "watson_governance_plan" {
  default     = "do not install"
  description = "Resource plan used to provision the watsonx Governance instance."
  type        = string
  validation {
    condition = anytrue([
      var.watson_governance_plan == "do not install",
      var.watson_governance_plan == "lite",
      var.watson_governance_plan == "standard-v2",
      var.watson_governance_plan == "essentials",
    ])
    error_message = "The plan to use must be one of: lite, standard-v2 or essentials"
  }
}

variable "project_name" {
  description = "Name of the watson project to create."
  type        = string
  default     = "demo"
}

variable "project_description" {
  description = "Description of the watson project to create."
  type        = string
  default     = "Watson Project created via watsonx-ai SaaS DA"
}

variable "project_tags" {
  description = "Tags to attach to the watson project to create."
  type        = list(string)
  default     = ["watsonx-ai-SaaS"]
}
