variable "ibmcloud_api_key" {
  description = "Used with the Terraform IBM-Cloud/ibm provider."
  sensitive   = true
  type        = string
}

variable "watsonx_admin_api_key" {
  default     = null
  description = "Used to call Watson APIs to configure the user and the project."
  sensitive   = true
  type        = string
}

variable "location" {
  default     = "us-south"
  description = "Used with the Terraform IBM-Cloud/ibm provider as well as resource creation."
  type        = string
  validation {
    condition     = contains(["eu-de", "us-south"], var.location)
    error_message = "The IBM Cloud location used must be eu-de or us-south."
  }
}

variable "use_existing_resource_group" {
  type        = bool
  description = "Determines whether to use an existing resource group."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or an existing resource group in which to provision resources to."
}

variable "resource_prefix" {
  description = "The name to be used on all Watson resource as prefix"
  type        = string
  default     = "watsonx-poc"

  validation {
    condition     = var.resource_prefix != "" && length(var.resource_prefix) <= 25
    error_message = "You must provide a value for the resource_prefix variable and the resource_prefix length must be less than 25 characters."
  }
}

variable "cos_plan" {
  default     = "standard"
  description = "Resource plan used to provision the Cloud Object Storage instance."
  type        = string
  validation {
    condition     = contains(["standard"], var.cos_plan)
    error_message = "The resource plan you use must be standard."
  }
}

variable "watson_machine_learning_plan" {
  default     = "v2-standard"
  description = "Resource plan used to provision the Watson Machine Learning instance."
  type        = string
  validation {
    condition     = contains(["lite", "v2-professional", "v2-standard"], var.watson_machine_learning_plan)
    error_message = "The resource plan you use must be lite, v2-professional, or v2-standard."
  }
}

variable "watson_studio_plan" {
  default     = "professional-v1"
  description = "Resource plan used to provision the Watson Studio instance."
  type        = string
  validation {
    condition     = contains(["free-v1", "professional-v1"], var.watson_studio_plan)
    error_message = "The resource plan you use must be free-v1 or professional-v1"
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
    error_message = "The resource plan you use must be plus, enterprise, or premium."
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
      var.watson_assistant_plan == "enterprisedataisolation",
    ])
    error_message = "The resource plan you use must be free, trial, plus-trial, enterprise, or enterprisedataisolation."
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
      var.watson_governance_plan == "essentials",
    ])
    error_message = "The resource plan you use must be lite or essentials."
  }
}

variable "project_name" {
  description = "Name of the watson project."
  type        = string
  default     = "demo"
}

variable "project_description" {
  description = "Description of the watson project."
  type        = string
  default     = "Watson Project created via watsonx-ai SaaS DA"
}

variable "project_tags" {
  description = "Tags to attach to the watson project."
  type        = list(string)
  default     = ["watsonx-ai-SaaS"]
}
