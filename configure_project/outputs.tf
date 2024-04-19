output "project_id" {
  value       = trimprefix(resource.restapi_object.configure_project[0].id, "/v2/projects/")
  description = "ID of the created project"
}

output "project_id_object" {
  value       = resource.restapi_object.configure_project[0]
  description = "ID of the created project"
}
