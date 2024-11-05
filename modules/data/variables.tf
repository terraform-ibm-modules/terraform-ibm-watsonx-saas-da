
variable "ibmcloud_api_key" {
  description = "The API key that's used with the IBM Cloud Terraform IBM provider."
  sensitive   = true
  type        = string
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

variable "location" {
  default     = "us-south"
  description = "The location that's used with the IBM Cloud Terraform IBM provider. It's also used during resource creation."
  type        = string
  validation {
    condition     = contains(["eu-de", "us-south", "eu-gb", "jp-tok"], var.location)
    error_message = "You must specify `eu-de`, `eu-gb`, `jp-tok` or `us-south` as the IBM Cloud location."
  }
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

variable "existing_data_instance" {
  default     = null
  description = "CRN of the an existing watsonx.data instance."
  type        = string
}

variable "watsonx_data_plan" {
  default     = "do not install"
  description = "The plan that's used to provision the watsonx.data instance."
  type        = string
  validation {
    condition = anytrue([
      var.watsonx_data_plan == "do not install",
      var.watsonx_data_plan == "lakehouse-enterprise",
      var.watsonx_data_plan == "lite",
    ])
    error_message = "You must use a lakehouse-enterprise or lite plan. Learn more. "
  }
}
