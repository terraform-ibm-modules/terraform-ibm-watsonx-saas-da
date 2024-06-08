output "watsonx_project_id" {
  value       = local.watsonx_project_id
  description = "The ID watsonx project that's created."
}

output "watsonx_project_location" {
  value       = resource.restapi_object.configure_project.id
  description = "The location watsonx project that's created."
}

output "watsonx_project_bucket_name" {
  value       = local.watsonx_project_data.entity.storage.properties.bucket_name
  description = "The name of the COS bucket created by the watsonx project."
}
