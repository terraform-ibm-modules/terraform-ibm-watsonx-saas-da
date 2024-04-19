output "project_id" {
  value       = local.project_id
  description = "ID of the created project."
}

output "project_location" {
  value       = resource.restapi_object.configure_project[0].id
  description = "Location of the created project"
}
