variable "ibmcloud_api_key" {
  description = "The API key that's used with the IBM Cloud Terraform and IBM provider."
  sensitive   = true
  type        = string
}

variable "watsonx_admin_api_key" {
  default     = null
  description = "The API key that's used to call Watson APIs to configure the user and the project."
  sensitive   = true
  type        = string
}

variable "location" {
  default     = "us-south"
  description = "The location that's used with the IBM Cloud Terraform and IBM provider. It's also used during resource creation."
  type        = string
  validation {
    condition     = contains(["eu-de", "us-south"], var.location)
    error_message = "You must specify `eu-de` or `us-south` as the IBM Cloud location."
  }
}

variable "use_existing_resource_group" {
  type        = bool
  description = "Determines whether to use an existing resource group."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or an existing resource group where the resources are created."
}

variable "resource_prefix" {
  description = "The name to be used on all Watson resources as a prefix."
  type        = string
  default     = "watsonx-poc"

  validation {
    condition     = var.resource_prefix != "" && length(var.resource_prefix) <= 25
    error_message = "You must provide a value for the resource_prefix variable and the resource_prefix length can't exceed 25 characters."
  }
}

variable "cos_plan" {
  default     = "standard"
  description = "The plan that's used to provision the Cloud Object Storage instance."
  type        = string
  validation {
    condition     = contains(["standard"], var.cos_plan)
    error_message = "You must use a standard plan. Standard plan instances are the most common and are recommended for most workloads."
  }
}

variable "watson_machine_learning_plan" {
  default     = "v2-standard"
  description = "The plan that's used to provision the Watson Machine Learning instance."
  type        = string
  validation {
    condition     = contains(["lite", "v2-professional", "v2-standard"], var.watson_machine_learning_plan)
    error_message = "The plan must be lite, v2-professional, or v2-standard. Learn more."
  }
}

variable "watson_studio_plan" {
  default     = "professional-v1"
  description = "The plan that's used to provision the Watson Studio instance. The plan you choose for Watson Studio affects the features and capabilities that you can use."
  type        = string
  validation {
    condition     = contains(["free-v1", "professional-v1"], var.watson_studio_plan)
    error_message = "You must use a free-v1 or professional-v1 plan. Learn more."
  }
}

variable "watson_discovery_plan" {
  default     = "do not install"
  description = "The plan that's used to provision the Watson Discovery instance."
  type        = string
  validation {
    condition = anytrue([
      var.watson_discovery_plan == "do not install",
      var.watson_discovery_plan == "plus",
      var.watson_discovery_plan == "enterprise",
      var.watson_discovery_plan == "premium",
    ])
    error_message = "You must use a plus, enterprise, or premium plan. Learn more."
  }
}

variable "watson_assistant_plan" {
  default     = "do not install"
  description = "The plan that's used to provision the watsonx Assistance instance."
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
    error_message = "You must use a free, trial, plus-trial, enterprise, or enterprisedataisolation plan. Learn more."
  }
}

variable "watson_governance_plan" {
  default     = "do not install"
  description = "The plan used to provision the watsonx Governance instance. The available plans depend on the region where you are provisioning the service from the IBM Cloud catalog."
  type        = string
  validation {
    condition = anytrue([
      var.watson_governance_plan == "do not install",
      var.watson_governance_plan == "lite",
      var.watson_governance_plan == "essentials",
    ])
    error_message = "You must use a lite or essential plan. Learn more. "
  }
}

variable "watsonx_project_name" {
  description = "The name of the watson project."
  type        = string
  default     = "demo"
}

variable "watsonx_project_description" {
  description = "A description of the watson project that's created by the WatsonX.ai SaaS Deployable Architecture."
  type        = string
  default     = "Watson project created by the watsonx-ai SaaS deployable architecture."
}

variable "watsonx_project_tags" {
  description = "A list of tags associated with the watsonx project. Learn more."
  type        = list(string)
  default     = ["watsonx-ai-SaaS"]
}
