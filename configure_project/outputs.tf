output "watsonx_project_id" {
  value       = local.watsonx_project_id
  description = "ID of the created project."
}

output "watsonx_project_location" {
  value       = resource.restapi_object.configure_project.id
  description = "Location of the created project"
}
