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
  description = "A list of tags associated with the watsonx project. Learn more."
  type        = list(string)
}

############################################################
# COS variables
############################################################

variable "cos_guid" {
  description = "This GUID is the globally unique identifier for the Cloud Object Storage instance."
  type        = string
}

variable "cos_crn" {
  description = "This is used to identify the unique Cloud Object Storage instance CRN."
  type        = string
}

############################################################
# Machine Learning variables
############################################################

variable "machine_learning_guid" {
  description = "This GUID is the globally unique identifier for the machine learning instance."
  type        = string
}

variable "machine_learning_crn" {
  description = "This is used to identify the unique machine learning instance CRN.
  type        = string
}

variable "machine_learning_name" {
  description = "The name of the machine learning instance, which is a unique identifier for the instance."
  type        = string
}
