##############################################################################################################
# Output Variables
##############################################################################################################

output "resource_group_id" {
  value       = module.resource_group.resource_group_id
  description = "The resource group ID that's used to provision the resources."
}

##############################################################################################################
# watsonx Project Configuration
##############################################################################################################

output "watsonx_platform_endpoint" {
  description = "The endpoint of the watsonx platform."
  value       = "${local.dataplatform_ui}/wx/home?context=wx"
}

output "watsonx_project_id" {
  value       = var.watsonx_project_name == null || var.watsonx_project_name == "" ? null : module.configure_project[0].watsonx_project_id
  description = "The ID watsonx project that's created."
}

output "watsonx_project_location" {
  value       = var.watsonx_project_name == null || var.watsonx_project_name == "" ? null : module.configure_project[0].watsonx_project_location
  description = "The location watsonx project that's created."
}

output "watsonx_project_bucket_name" {
  value       = var.watsonx_project_name == null || var.watsonx_project_name == "" ? null : module.configure_project[0].watsonx_project_bucket_name
  description = "The name of the COS bucket created by the watsonx project."
}

output "watsonx_project_url" {
  value       = var.watsonx_project_name == null || var.watsonx_project_name == "" ? null : module.configure_project[0].watsonx_project_url
  description = "The URL of the watsonx project that's created."
}

##############################################################################################################
# watsonx Assistant
##############################################################################################################

output "watsonx_assistant_crn" {
  description = "The CRN of the watsonx Assistant instance."
  value       = local.watsonx_assistant_crn
}

output "watsonx_assistant_guid" {
  description = "The GUID of the watsonx Assistant instance."
  value       = local.watsonx_assistant_guid
}

output "watsonx_assistant_name" {
  description = "The name of the watsonx Assistant instance."
  value       = local.watsonx_assistant_name
}

output "watsonx_assistant_plan_id" {
  description = "The plan ID of the watsonx Assistant instance."
  value       = local.watsonx_assistant_plan_id
}

output "watsonx_assistant_dashboard_url" {
  description = "The dashboard URL of the watsonx Assistant instance."
  value       = local.watsonx_assistant_dashboard_url
}

##############################################################################################################
# Watson Discovery
##############################################################################################################

output "watson_discovery_crn" {
  description = "The CRN of the Watson Discovery instance."
  value       = local.watson_discovery_crn
}

output "watson_discovery_guid" {
  description = "The GUID of the Watson Discovery instance."
  value       = local.watson_discovery_guid
}

output "watson_discovery_name" {
  description = "The name of the Watson Discovery instance."
  value       = local.watson_discovery_name
}

output "watson_discovery_plan_id" {
  description = "The plan ID of the Watson Discovery instance."
  value       = local.watson_discovery_plan_id
}

output "watson_discovery_dashboard_url" {
  description = "The dashboard URL of the Watson Discovery instance."
  value       = local.watson_discovery_dashboard_url
}

##############################################################################################################
# Watson Machine Learning
##############################################################################################################

output "watson_machine_learning_crn" {
  description = "The CRN of the Watson Machine Learning instance."
  value       = local.watson_machine_learning_crn
}

output "watson_machine_learning_guid" {
  description = "The GUID of the Watson Machine Learning instance."
  value       = local.watson_machine_learning_guid
}

output "watson_machine_learning_name" {
  description = "The name of the Watson Machine Learning instance."
  value       = local.watson_machine_learning_name
}

output "watson_machine_learning_plan_id" {
  description = "The plan ID of the Watson Machine Learning instance."
  value       = local.watson_machine_learning_plan_id
}

output "watson_machine_learning_dashboard_url" {
  description = "The dashboard URL of the Watson Machine Learning instance."
  value       = local.watson_machine_learning_dashboard_url
}

##############################################################################################################
# Watson Studio
##############################################################################################################

output "watson_studio_crn" {
  description = "The CRN of the Watson Studio instance."
  value       = local.watson_studio_crn
}

output "watson_studio_guid" {
  description = "The GUID of the Watson Studio instance."
  value       = local.watson_studio_guid
}

output "watson_studio_name" {
  description = "The name of the Watson Studio instance."
  value       = local.watson_studio_name
}

output "watson_studio_plan_id" {
  description = "The plan ID of the Watson Studio instance."
  value       = local.watson_studio_plan_id
}

output "watson_studio_dashboard_url" {
  description = "The dashboard URL of the Watson Studio instance."
  value       = local.watson_studio_dashboard_url
}

##############################################################################################################
# watsonx.governance
##############################################################################################################

output "watsonx_governance_crn" {
  description = "The CRN of the watsonx.governance instance."
  value       = local.watsonx_governance_crn
}

output "watsonx_governance_guid" {
  description = "The GUID of the watsonx.governance instance."
  value       = local.watsonx_governance_guid
}

output "watsonx_governance_name" {
  description = "The name of the watsonx.governance instance."
  value       = local.watsonx_governance_name
}

output "watsonx_governance_plan_id" {
  description = "The plan ID of the watsonx.governance instance."
  value       = local.watsonx_governance_plan_id
}

output "watsonx_governance_dashboard_url" {
  description = "The dashboard URL of the watsonx.governance instance."
  value       = local.watsonx_governance_dashboard_url
}

##############################################################################################################
# watsonx.data
##############################################################################################################

output "watsonx_data_crn" {
  description = "The CRN of the watsonx.data instance."
  value       = local.watsonx_data_crn
}

output "watsonx_data_guid" {
  description = "The GUID of the watsonx.data instance."
  value       = local.watsonx_data_guid
}

output "watsonx_data_name" {
  description = "The name of the watsonx.data instance."
  value       = local.watsonx_data_name
}

output "watsonx_data_plan_id" {
  description = "The plan ID of the watsonx.data instance."
  value       = local.watsonx_data_plan_id
}

output "watsonx_data_dashboard_url" {
  description = "The dashboard URL of the watsonx.data instance."
  value       = local.watsonx_data_dashboard_url
}

##############################################################################################################
# watsonx Orchestrate
##############################################################################################################

output "watsonx_orchestrate_crn" {
  description = "The CRN of the watsonx Orchestrate instance."
  value       = local.watsonx_orchestrate_crn
}

output "watsonx_orchestrate_guid" {
  description = "The GUID of the watsonx Orchestrate instance."
  value       = local.watsonx_orchestrate_guid
}

output "watsonx_orchestrate_name" {
  description = "The name of the watsonx Orchestrate instance."
  value       = local.watsonx_orchestrate_name
}

output "watsonx_orchestrate_plan_id" {
  description = "The plan ID of the watsonx Orchestrate instance."
  value       = local.watsonx_orchestrate_plan_id
}

output "watsonx_orchestrate_dashboard_url" {
  description = "The dashboard URL of the watsonx Orchestrate instance."
  value       = local.watsonx_orchestrate_dashboard_url
}

output "next_steps_text" {
  value       = "Your watsonx Environment is ready."
  description = "Next steps text"
}

output "next_step_primary_label" {
  value       = "Go to watsonx.ai Project"
  description = "Primary label"
}

output "next_step_primary_url" {
  value       =  module.configure_project[0].watsonx_project_url
  description = "Primary URL"
}

