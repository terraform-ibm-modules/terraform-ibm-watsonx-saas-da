############################################################
# Watson variables
############################################################

variable "watsonx_admin_api_key" {
  description = "The Watson API key needed to call Watson APIs for configuring projects."
  sensitive   = true
  type        = string
}

variable "watsonx_project_name" {
  description = "The name of the Watson project, which serves as a unique identifier for the project."
  type        = string
}
variable "watsonx_project_description" {
  description = "This provides a simple overview of the Watson project."
  type        = string
}

variable "watsonx_project_tags" {
  description = "This defines the tags associated with the Watson project."
  type        = list(string)
}

############################################################
# COS variables
############################################################

variable "cos_guid" {
  description = "The cos guid is the globally unique identifier for the Cloud Object Storage instance."
  type        = string
}

variable "cos_crn" {
  description = "This is to identify the unique Cloud Object Storage (COS) instance CRN."
  type        = string
}

############################################################
# Machine Learning variables
############################################################

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
