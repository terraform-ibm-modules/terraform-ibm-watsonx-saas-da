variable "watsonx_admin_api_key" {
  description = "Used to call Watson APIs to configure the user and the project"
  sensitive   = true
  type        = string
}

variable "resource_group_id" {
  description = "ID of the IBM Cloud resource group in which resources are created"
  type        = string
}
