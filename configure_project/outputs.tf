output "project_id" {
  value       = trimprefix(resource.restapi_object.configure_project[0].id, "/v2/projects/")
  description = "ID of the created project"
}

output "project_id_regex" {
  value = local.project_id
  description = "Project ID Regex"
}
