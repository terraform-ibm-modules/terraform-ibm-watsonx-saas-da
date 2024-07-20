<!-- Update the title -->
# Watsonx.ai SaaS with Assistant and Governance Deployable Architecture

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Graduated (Supported)](https://img.shields.io/badge/Status-Graduated%20(Supported)-brightgreen)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-watsonx-saas-da?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-watsonx-saas-da/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!-- Add a description of module(s) in this repo -->
The Watsonx.ai SaaS with Assistant and Governance Deployable Architecture is designed to automate the deployment and configuration of the IBM watsonx platform in an IBM Cloud account. The IBM watsonx platform is made of several services working together to offer AI capabilities to end users, who can explore them using [IBM watsonx projects](https://dataplatform.cloud.ibm.com/docs/content/wsj/manage-data/manage-projects.html?context=wx&audience=wdp).

In addition, this deployable architecture configures a starter project for an IBM Cloud user.

<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-watsonx-saas-da](#terraform-ibm-watsonx-saas-da)
* [Examples](./examples)
    * [Basic example](./examples/basic)
    * [Complete example](./examples/complete)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


<!--
If this repo contains any reference architectures, uncomment the heading below and links to them.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in Authoring Guidelines in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->
<!-- ## Reference architectures -->


<!-- This heading should always match the name of the root level module (aka the repo name) -->
## terraform-ibm-watsonx-saas-da

The solution supports the following:

- Creating a new resource group, or using an existing one.
- Provisioning the following services:
  - Watson Machine Learning
  - Watson Studio
  - Cloud Object Storage.
- Configuring the IBM watsonx profile and creating a starter IBM watsonx project.
  for an IBM Cloud user, who becomes the `admin` of the `IBM watsonx project`.

As result the IBM watsonx admin can log into [IBM watsonx](https://dataplatform.cloud.ibm.com/login) in the target account and start experimenting with the starter project.

Optionally, the solution supports:

- Enabling the storage delegation for the provisioned Cloud Object Storage instance using your own encryption keys with Key Protect.
- Provisioning of one or more of the services, with a selectable
  service plan:
  - watsonx.data
  - watsonx.governance
  - watsonx Assistant
  - Watson Discovery.

### Required IAM access policies

<!-- PERMISSIONS REQUIRED TO RUN MODULE
If this module requires permissions, uncomment the following block and update
the sample permissions, following the format.
Replace the sample Account and IBM Cloud service names and roles with the
information in the console at
Manage > Access (IAM) > Access groups > Access policies.
-->

The following permissions are required to deploy this solution.

- Administrator role on All Account Management services to create a new resource group, and to enable storage delegation for the Cloud Object Storage instance.
- Manager service role on the Key Protect instance used for storage delegation.
- Editor platform role on Watson Machine Learning to create and delete the service.
- Editor platform role on Watson Studio to create or delete the service.
- Editor platform role on Cloud Object Storage to create and delete the service.
- Editor platform role on watsonx.data if you must provision.
- Editor platform role on watsonx.governance if you must provision.
- Editor platform role on watsonx Assistant if you must provision.
- Editor platform role on Watson Discovery if you must provision.

The IBM watsonx administrator needs the following permissions:

- Administrator role on All Account Management services.
- Administrator role on All Identity and Access enabled services.
- Manager service role on Cloud Object Storage to create service credentials. That is not needed if you configure storage delegation.

You can use the IBM provided [IAM Access Group Terraform Module](https://github.com/terraform-ibm-modules/terraform-ibm-iam-access-group)
to configure `deployers` and `watsonx admins` access groups and add members to them.

<!-- NO PERMISSIONS FOR MODULE
If no permissions are required for the module, uncomment the following
statement instead the previous block.
-->

<!-- No permissions are needed to run this module.-->


<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.66.0 |
| <a name="requirement_restapi"></a> [restapi](#requirement\_restapi) | >= 1.19.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_configure_project"></a> [configure\_project](#module\_configure\_project) | ./configure_project | n/a |
| <a name="module_configure_user"></a> [configure\_user](#module\_configure\_user) | ./configure_user | n/a |
| <a name="module_cos"></a> [cos](#module\_cos) | terraform-ibm-modules/cos/ibm//modules/fscloud | 8.8.2 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-ibm-modules/resource-group/ibm | 1.1.6 |
| <a name="module_storage_delegation"></a> [storage\_delegation](#module\_storage\_delegation) | ./storage_delegation | n/a |

### Resources

| Name | Type |
|------|------|
| [ibm_resource_instance.assistant_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.data_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.discovery_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.governance_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.machine_learning_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.studio_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_iam_auth_token.restapi](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/iam_auth_token) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cos_kms_crn"></a> [cos\_kms\_crn](#input\_cos\_kms\_crn) | Key Protect service instance CRN used to encrypt the COS buckets used by the watsonx projects. | `string` | `null` | no |
| <a name="input_cos_kms_key_crn"></a> [cos\_kms\_key\_crn](#input\_cos\_kms\_key\_crn) | Key Protect key CRN used to encrypt the COS buckets used by the watsonx projects. If not set, then the cos\_kms\_new\_key\_name must be specified. | `string` | `null` | no |
| <a name="input_cos_kms_new_key_name"></a> [cos\_kms\_new\_key\_name](#input\_cos\_kms\_new\_key\_name) | Name of the Key Protect key to create for encrypting the COS buckets used by the watsonx projects. | `string` | `""` | no |
| <a name="input_cos_kms_ring_id"></a> [cos\_kms\_ring\_id](#input\_cos\_kms\_ring\_id) | The identifier of the Key Protect ring to create the cos\_kms\_new\_key\_name into. If it is not set, then the new key will be created in the default ring. | `string` | `null` | no |
| <a name="input_cos_plan"></a> [cos\_plan](#input\_cos\_plan) | The plan that's used to provision the Cloud Object Storage instance. | `string` | `"standard"` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The API key that's used with the IBM Cloud Terraform IBM provider. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location that's used with the IBM Cloud Terraform IBM provider. It's also used during resource creation. | `string` | `"us-south"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of a new or an existing resource group where the resources are created. | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The name to be used on all Watson resources as a prefix. | `string` | `"watsonx-poc"` | no |
| <a name="input_use_existing_resource_group"></a> [use\_existing\_resource\_group](#input\_use\_existing\_resource\_group) | Determines whether to use an existing resource group. | `bool` | `false` | no |
| <a name="input_watson_discovery_plan"></a> [watson\_discovery\_plan](#input\_watson\_discovery\_plan) | The plan that's used to provision the Watson Discovery instance. | `string` | `"do not install"` | no |
| <a name="input_watson_machine_learning_plan"></a> [watson\_machine\_learning\_plan](#input\_watson\_machine\_learning\_plan) | The plan that's used to provision the Watson Machine Learning instance. | `string` | `"v2-standard"` | no |
| <a name="input_watson_studio_plan"></a> [watson\_studio\_plan](#input\_watson\_studio\_plan) | The plan that's used to provision the Watson Studio instance. The plan you choose for Watson Studio affects the features and capabilities that you can use. | `string` | `"professional-v1"` | no |
| <a name="input_watsonx_admin_api_key"></a> [watsonx\_admin\_api\_key](#input\_watsonx\_admin\_api\_key) | The API key of the IBM watsonx administrator in the target account. The API key is used to configure the user and the project. | `string` | `null` | no |
| <a name="input_watsonx_assistant_plan"></a> [watsonx\_assistant\_plan](#input\_watsonx\_assistant\_plan) | The plan that's used to provision the watsonx Assistance instance. | `string` | `"do not install"` | no |
| <a name="input_watsonx_data_plan"></a> [watsonx\_data\_plan](#input\_watsonx\_data\_plan) | The plan that's used to provision the watsonx.data instance. | `string` | `"do not install"` | no |
| <a name="input_watsonx_governance_plan"></a> [watsonx\_governance\_plan](#input\_watsonx\_governance\_plan) | The plan used to provision the watsonx.governance instance. The available plans depend on the region where you are provisioning the service from the IBM Cloud catalog. | `string` | `"do not install"` | no |
| <a name="input_watsonx_project_description"></a> [watsonx\_project\_description](#input\_watsonx\_project\_description) | A description of the watson project that's created by the WatsonX.ai SaaS Deployable Architecture. | `string` | `"Watson project created by the watsonx-ai SaaS deployable architecture."` | no |
| <a name="input_watsonx_project_name"></a> [watsonx\_project\_name](#input\_watsonx\_project\_name) | The name of the watson project. | `string` | `"demo"` | no |
| <a name="input_watsonx_project_tags"></a> [watsonx\_project\_tags](#input\_watsonx\_project\_tags) | A list of tags associated with the watsonx project. Each tag consists of a single string containing up to 255 characters. These tags can include spaces, letters, numbers, underscores, dashes, as well as the symbols # and @. | `list(string)` | <pre>[<br>  "watsonx-ai-SaaS"<br>]</pre> | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | The resource group ID that's used to provision the resources. |
| <a name="output_watson_discovery_crn"></a> [watson\_discovery\_crn](#output\_watson\_discovery\_crn) | The CRN of the Watson Discovery instance. |
| <a name="output_watson_discovery_dashboard_url"></a> [watson\_discovery\_dashboard\_url](#output\_watson\_discovery\_dashboard\_url) | The dashboard URL of the Watson Discovery instance. |
| <a name="output_watson_discovery_guid"></a> [watson\_discovery\_guid](#output\_watson\_discovery\_guid) | The GUID of the Watson Discovery instance. |
| <a name="output_watson_discovery_name"></a> [watson\_discovery\_name](#output\_watson\_discovery\_name) | The name of the Watson Discovery instance. |
| <a name="output_watson_discovery_plan_id"></a> [watson\_discovery\_plan\_id](#output\_watson\_discovery\_plan\_id) | The plan ID of the Watson Discovery instance. |
| <a name="output_watson_machine_learning_crn"></a> [watson\_machine\_learning\_crn](#output\_watson\_machine\_learning\_crn) | The CRN of the Watson Machine Learning instance. |
| <a name="output_watson_machine_learning_dashboard_url"></a> [watson\_machine\_learning\_dashboard\_url](#output\_watson\_machine\_learning\_dashboard\_url) | The dashboard URL of the Watson Machine Learning instance. |
| <a name="output_watson_machine_learning_guid"></a> [watson\_machine\_learning\_guid](#output\_watson\_machine\_learning\_guid) | The GUID of the Watson Machine Learning instance. |
| <a name="output_watson_machine_learning_name"></a> [watson\_machine\_learning\_name](#output\_watson\_machine\_learning\_name) | The name of the Watson Machine Learning instance. |
| <a name="output_watson_machine_learning_plan_id"></a> [watson\_machine\_learning\_plan\_id](#output\_watson\_machine\_learning\_plan\_id) | The plan ID of the Watson Machine Learning instance. |
| <a name="output_watson_studio_crn"></a> [watson\_studio\_crn](#output\_watson\_studio\_crn) | The CRN of the Watson Studio instance. |
| <a name="output_watson_studio_dashboard_url"></a> [watson\_studio\_dashboard\_url](#output\_watson\_studio\_dashboard\_url) | The dashboard URL of the Watson Studio instance. |
| <a name="output_watson_studio_guid"></a> [watson\_studio\_guid](#output\_watson\_studio\_guid) | The GUID of the Watson Studio instance. |
| <a name="output_watson_studio_name"></a> [watson\_studio\_name](#output\_watson\_studio\_name) | The name of the Watson Studio instance. |
| <a name="output_watson_studio_plan_id"></a> [watson\_studio\_plan\_id](#output\_watson\_studio\_plan\_id) | The plan ID of the Watson Studio instance. |
| <a name="output_watsonx_assistant_crn"></a> [watsonx\_assistant\_crn](#output\_watsonx\_assistant\_crn) | The CRN of the watsonx Assistant instance. |
| <a name="output_watsonx_assistant_dashboard_url"></a> [watsonx\_assistant\_dashboard\_url](#output\_watsonx\_assistant\_dashboard\_url) | The dashboard URL of the watsonx Assistant instance. |
| <a name="output_watsonx_assistant_guid"></a> [watsonx\_assistant\_guid](#output\_watsonx\_assistant\_guid) | The GUID of the watsonx Assistant instance. |
| <a name="output_watsonx_assistant_name"></a> [watsonx\_assistant\_name](#output\_watsonx\_assistant\_name) | The name of the watsonx Assistant instance. |
| <a name="output_watsonx_assistant_plan_id"></a> [watsonx\_assistant\_plan\_id](#output\_watsonx\_assistant\_plan\_id) | The plan ID of the watsonx Assistant instance. |
| <a name="output_watsonx_data_crn"></a> [watsonx\_data\_crn](#output\_watsonx\_data\_crn) | The CRN of the watsonx.data instance. |
| <a name="output_watsonx_data_dashboard_url"></a> [watsonx\_data\_dashboard\_url](#output\_watsonx\_data\_dashboard\_url) | The dashboard URL of the watsonx.data instance. |
| <a name="output_watsonx_data_guid"></a> [watsonx\_data\_guid](#output\_watsonx\_data\_guid) | The GUID of the watsonx.data instance. |
| <a name="output_watsonx_data_name"></a> [watsonx\_data\_name](#output\_watsonx\_data\_name) | The name of the watsonx.data instance. |
| <a name="output_watsonx_data_plan_id"></a> [watsonx\_data\_plan\_id](#output\_watsonx\_data\_plan\_id) | The plan ID of the watsonx.data instance. |
| <a name="output_watsonx_governance_crn"></a> [watsonx\_governance\_crn](#output\_watsonx\_governance\_crn) | The CRN of the watsonx.governance instance. |
| <a name="output_watsonx_governance_dashboard_url"></a> [watsonx\_governance\_dashboard\_url](#output\_watsonx\_governance\_dashboard\_url) | The dashboard URL of the watsonx.governance instance. |
| <a name="output_watsonx_governance_guid"></a> [watsonx\_governance\_guid](#output\_watsonx\_governance\_guid) | The GUID of the watsonx.governance instance. |
| <a name="output_watsonx_governance_name"></a> [watsonx\_governance\_name](#output\_watsonx\_governance\_name) | The name of the watsonx.governance instance. |
| <a name="output_watsonx_governance_plan_id"></a> [watsonx\_governance\_plan\_id](#output\_watsonx\_governance\_plan\_id) | The plan ID of the watsonx.governance instance. |
| <a name="output_watsonx_platform_endpoint"></a> [watsonx\_platform\_endpoint](#output\_watsonx\_platform\_endpoint) | The endpoint of the watsonx platform. |
| <a name="output_watsonx_project_bucket_name"></a> [watsonx\_project\_bucket\_name](#output\_watsonx\_project\_bucket\_name) | The name of the COS bucket created by the watsonx project. |
| <a name="output_watsonx_project_id"></a> [watsonx\_project\_id](#output\_watsonx\_project\_id) | The ID watsonx project that's created. |
| <a name="output_watsonx_project_location"></a> [watsonx\_project\_location](#output\_watsonx\_project\_location) | The location watsonx project that's created. |
| <a name="output_watsonx_project_url"></a> [watsonx\_project\_url](#output\_watsonx\_project\_url) | The URL of the watsonx project that's created. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
