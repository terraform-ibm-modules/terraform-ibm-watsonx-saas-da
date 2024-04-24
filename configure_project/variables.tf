variable "watsonx_admin_api_key" {
  description = "Used to call Watson APIs to configure the user and the project"
  sensitive   = true
  type        = string
}

variable "watsonx_project_name" {
  description = "Name of the Watson project to create"
  type        = string
}

variable "watsonx_project_name_suffix" {
  description = "(Optional) The suffix attached to the newly provisioned watson project name."
  type        = string
  default     = null
}

variable "cos_guid" {
  description = "GUID of the COS instance"
  type        = string
}

variable "cos_crn" {
  description = "CRN of the COS instance"
  type        = string
}

variable "watsonx_project_description" {
  description = "Description of the Watson project to create"
  type        = string
}

variable "watsonx_project_tags" {
  description = "Tags of the Watson project to create"
  type        = list(string)
}

variable "machine_learning_guid" {
  description = "GUID of the ML instance"
  type        = string
}

variable "machine_learning_crn" {
  description = "CRN of the ML instance"
  type        = string
}

variable "machine_learning_name" {
  description = "Name of the ML instance"
  type        = string
}
