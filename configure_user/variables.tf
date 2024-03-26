variable "ibmcloud_api_key" {
  description = "Used with the Terraform IBM-Cloud/ibm provider"
  sensitive   = true
  type        = string
}

variable "resource_group_id" {
  description = "ID of the IBM Cloud resource group in which resources are created"
  type        = string
}

variable "location" {
  description = "Used with the Terraform IBM-Cloud/ibm provider as well as resource creation."
  type        = string
}
