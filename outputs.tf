output "watson_platform_endpoint" {
  description = "The endpoint of the watsonx platform."
  value       = "https://dataplatform.cloud.ibm.com/wx/home?context=wx"
}

output "watsonx_assistant_crn" {
  description = "The CRN of the WatsonX Assistant instance."
  value       = var.watson_assistant_plan != "do not install" ? ibm_resource_instance.assistant_instance[0].crn : null
}

output "watsonx_assistant_guid" {
  description = "The GUID of the WatsonX Assistant instance."
  value       = var.watson_assistant_plan != "do not install" ? ibm_resource_instance.assistant_instance[0].guid : null
}

output "watsonx_assistant_name" {
  description = "The name of the WatsonX Assistant instance."
  value       = var.watson_assistant_plan != "do not install" ? ibm_resource_instance.assistant_instance[0].resource_name : null
}

output "watsonx_assistant_plan_id" {
  description = "The plan ID of the WatsonX Assistant instance."
  value       = var.watson_assistant_plan != "do not install" ? ibm_resource_instance.assistant_instance[0].resource_plan_id : null
}

output "watsonx_assistant_dashboard_url" {
  description = "The dashboard URL of the WatsonX Assistant instance."
  value       = var.watson_assistant_plan != "do not install" ? ibm_resource_instance.assistant_instance[0].dashboard_url : null
}

output "watsonx_discovery_crn" {
  description = "The CRN of the WatsonX Discovery instance."
  value       = var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].crn : null
}

output "watsonx_discovery_guid" {
  description = "The GUID of the WatsonX Discovery instance."
  value       = var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].guid : null
}

output "watsonx_discovery_name" {
  description = "The name of the WatsonX Discovery instance."
  value       = var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].resource_name : null
}

output "watsonx_discovery_plan_id" {
  description = "The plan ID of the WatsonX Discovery instance."
  value       = var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].resource_plan_id : null
}

output "watsonx_discovery_dashboard_url" {
  description = "The dashboard URL of the WatsonX Discovery instance."
  value       = var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].dashboard_url : null
}

output "watson_machine_learning_crn" {
  description = "The CRN of the Watson Machine Learning instance."
  value       = ibm_resource_instance.machine_learning_instance.crn
}

output "watson_machine_learning_guid" {
  description = "The GUID of the Watson Machine Learning instance."
  value       = ibm_resource_instance.machine_learning_instance.guid
}

output "watson_machine_learning_name" {
  description = "The name of the Watson Machine Learning instance."
  value       = ibm_resource_instance.machine_learning_instance.resource_name
}

output "watson_machine_learning_plan_id" {
  description = "The plan ID of the Watson Machine Learning instance."
  value       = ibm_resource_instance.machine_learning_instance.resource_plan_id
}

output "watson_machine_learning_dashboard_url" {
  description = "The dashboard URL of the Watson Machine Learning instance."
  value       = ibm_resource_instance.machine_learning_instance.dashboard_url
}

output "watson_studio_crn" {
  description = "The CRN of the Watson Studio instance."
  value       = ibm_resource_instance.studio_instance.crn
}

output "watson_studio_guid" {
  description = "The GUID of the Watson Studio instance."
  value       = ibm_resource_instance.studio_instance.guid
}

output "watson_studio_name" {
  description = "The name of the Watson Studio instance."
  value       = ibm_resource_instance.studio_instance.resource_name
}

output "watson_studio_plan_id" {
  description = "The plan ID of the Watson Studio instance."
  value       = ibm_resource_instance.studio_instance.resource_plan_id
}

output "watson_studio_dashboard_url" {
  description = "The dashboard URL of the Watson Studio instance."
  value       = ibm_resource_instance.studio_instance.dashboard_url
}

output "watson_governance_crn" {
  description = "The CRN of the Watson Governance instance."
  value       = var.watson_governance_plan != "do not install" ? ibm_resource_instance.governance_instance[0].crn : null
}

output "watson_governance_guid" {
  description = "The GUID of the Watson Governance instance."
  value       = var.watson_governance_plan != "do not install" ? ibm_resource_instance.governance_instance[0].guid : null
}

output "watson_governance_name" {
  description = "The name of the Watson Governance instance."
  value       = var.watson_governance_plan != "do not install" ? ibm_resource_instance.governance_instance[0].resource_name : null
}

output "watson_governance_plan_id" {
  description = "The plan ID of the Watson Governance instance."
  value       = var.watson_governance_plan != "do not install" ? ibm_resource_instance.governance_instance[0].resource_plan_id : null
}

output "watson_governance_dashboard_url" {
  description = "The dashboard URL of the Watson Governance instance."
  value       = var.watson_governance_plan != "do not install" ? ibm_resource_instance.governance_instance[0].dashboard_url : null
}

output "watsonx_project_id" {
  value       = module.configure_project.watsonx_project_id
  description = "The ID watsonx project that's created."
}

output "watsonx_project_location" {
  value       = module.configure_project.watsonx_project_location
  description = "The location watsonx project that's created."
}

output "watsonx_project_url" {
  value       = "https://dataplatform.cloud.ibm.com/projects/${module.configure_project.watsonx_project_id}?context=wx&sync_account_id=${ibm_resource_instance.machine_learning_instance.account_id}"
  description = "The URL of the watsonx project that's created."
}

output "resource_group_id" {
  value       = module.resource_group.resource_group_id
  description = "The resource group ID that's used to provision the resources."
}
