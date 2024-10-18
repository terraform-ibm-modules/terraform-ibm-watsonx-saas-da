############################################################
# Watson variables
############################################################

variable "watsonx_project_name" {
  description = "The name of the watsonx project, which serves as a unique identifier for the project."
  type        = string
}

variable "watsonx_project_description" {
  description = "This provides a short summary of the watsonx project, explaining its purpose or goals briefly."
  type        = string
}

variable "watsonx_project_tags" {
  description = "A list of tags associated with the watsonx project. Each tag consists of a single string containing up to 255 characters. These tags can include spaces, letters, numbers, underscores, dashes, as well as the symbols # and @."
  type        = list(string)
}

variable "watsonx_project_delegated" {
  description = "Set to true if the COS instance is delegated by the account admin."
  type        = bool
  default     = false
}

variable "location" {
  description = "The location that's used with the IBM Cloud Terraform IBM provider. It's also used during resource creation."
  type        = string
}

variable "watsonx_mark_as_sensitive" {
  description = "Set to true to allow the WatsonX project to be created with 'Mark as sensitive' flag."
  type        = bool
  default     = false
}



############################################################
# COS variables
############################################################

variable "cos_guid" {
  description = "The globally unique identifier of the Cloud Object Storage instance."
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
  description = "This is used to identify the unique machine learning instance CRN."
  type        = string
}

variable "machine_learning_name" {
  description = "The name of the machine learning instance, which is a unique identifier for the instance."
  type        = string
}
