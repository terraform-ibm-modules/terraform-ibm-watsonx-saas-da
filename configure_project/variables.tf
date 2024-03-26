variable "project_name" {
  description = "Name of the Watson project to create"
  type        = string
}

variable "cos_guid" {
  description = "GUID of the COS instance"
  type        = string
}

variable "cos_crn" {
  description = "CRN of the COS instance"
  type        = string
}

variable "project_description" {
  description = "Description of the Watson project to create"
  type        = string
}

variable "project_tags" {
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
