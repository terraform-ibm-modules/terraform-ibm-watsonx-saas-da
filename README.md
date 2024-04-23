<!-- Update the title -->
# Watsonx SaaS Deployable Architecture (DA)

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Incubating (Not yet consumable)](https://img.shields.io/badge/status-Incubating%20(Not%20yet%20consumable)-red)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-module-template?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-module-template/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!-- Add a description of module(s) in this repo -->
The **Watsonx SaaS Deployment Architecture (Watsonx DA)** is designed to automate the deployment and
configuration of the **IBM watsonx** platform in an IBM Cloud Account.
The **IBM watsonx** platform is made of several services working together to offer AI capabilities to end users, who can explore them using [IBM watsonx projects](https://dataplatform.cloud.ibm.com/docs/content/wsj/manage-data/manage-projects.html?context=wx&audience=wdp).
On that purpose, the **Watsonx DA** also
configures a *starter project* for an IBM Cloud user.

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

- Creating a new resource group, or taking an existing one.
- Provisioning the services
  - `Watson Machine Learning`
  - `Watson Studio`
  - `Cloud Object Storage`.
- Configuring the `IBM watsonx profile` and creating a *starter* `IBM watsonx project`
  for an IBM Cloud user, who becomes the `admin` of the `IBM watsonx project` (`IBM watsonx admin` in the following).

As result the `IBM watsonx admin` can log into [IBM watsonx](https://dataplatform.cloud.ibm.com/login) in the target account and start experimenting
with the *starter* project.

Optionally, the solution supports:

- Provisioning of one or more of the services, with a selectable
  service plan:
  - `watsonx.governance`
  - `watsonx Assistant`
  - `Watson Discovery`.

### Required IAM access policies

<!-- PERMISSIONS REQUIRED TO RUN MODULE
If this module requires permissions, uncomment the following block and update
the sample permissions, following the format.
Replace the sample Account and IBM Cloud service names and roles with the
information in the console at
Manage > Access (IAM) > Access groups > Access policies.
-->

You need the following permissions to deploy this solution.

- All Account Management services
  - Administrator (only if you must create a new resource group)
- Watson Machine Learning
  - Editor platform role (to create and delete the service)
- Watson Studio
  - Editor platform role (to create and delete the service)
- Cloud Object Storage
  - Editor platform role (to create and delete the service)
- watsonx.governance
  - Editor platform role (only if you must provision)
- watsonx Assistant
  - Editor platform role (only if you must provision)
- Watson Discovery
  - Editor platform role (only if you must provision)

The `IBM watsonx admin` needs the following permissions.

- All Account Management services
  - Administrator
- All Identity and Access enabled services
  - Administrator

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <1.7.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.62.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_configure_project"></a> [configure\_project](#module\_configure\_project) | ./configure_project | n/a |
| <a name="module_configure_user"></a> [configure\_user](#module\_configure\_user) | ./configure_user | n/a |
| <a name="module_cos"></a> [cos](#module\_cos) | terraform-ibm-modules/cos/ibm//modules/fscloud | 8.1.10 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-ibm-modules/resource-group/ibm | 1.1.5 |

### Resources

| Name | Type |
|------|------|
| [ibm_resource_instance.assistant_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.discovery_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.governance_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.machine_learning_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.studio_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cos_plan"></a> [cos\_plan](#input\_cos\_plan) | Resource plan used to provision the Cloud Object Storage instance. | `string` | `"standard"` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | Used with the Terraform IBM-Cloud/ibm provider | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Used with the Terraform IBM-Cloud/ibm provider as well as resource creation. | `string` | `"us-south"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of a new or an existing resource group in which to provision resources to. | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Name to be used on all Watson resource as prefix | `string` | `"watsonx-poc"` | no |
| <a name="input_use_existing_resource_group"></a> [use\_existing\_resource\_group](#input\_use\_existing\_resource\_group) | Whether to use an existing resource group. | `bool` | `false` | no |
| <a name="input_watson_assistant_plan"></a> [watson\_assistant\_plan](#input\_watson\_assistant\_plan) | Resource plan used to provision the watsonx Assistance instance. | `string` | `"do not install"` | no |
| <a name="input_watson_discovery_plan"></a> [watson\_discovery\_plan](#input\_watson\_discovery\_plan) | Resource plan used to provision the Watson Discovery instance. | `string` | `"do not install"` | no |
| <a name="input_watson_governance_plan"></a> [watson\_governance\_plan](#input\_watson\_governance\_plan) | Resource plan used to provision the watsonx Governance instance. | `string` | `"do not install"` | no |
| <a name="input_watson_machine_learning_plan"></a> [watson\_machine\_learning\_plan](#input\_watson\_machine\_learning\_plan) | Resource plan used to provision the Watson Machine Learning instance. | `string` | `"v2-standard"` | no |
| <a name="input_watson_studio_plan"></a> [watson\_studio\_plan](#input\_watson\_studio\_plan) | Resource plan used to provision the Watson Studio instance. | `string` | `"professional-v1"` | no |
| <a name="input_watsonx_admin_api_key"></a> [watsonx\_admin\_api\_key](#input\_watsonx\_admin\_api\_key) | Used to call Watson APIs to configure the user and the project | `string` | `null` | no |
| <a name="input_watsonx_project_description"></a> [watsonx\_project\_description](#input\_watsonx\_project\_description) | Description of the watson project to create. | `string` | `"Watson Project created via watsonx-ai SaaS DA"` | no |
| <a name="input_watsonx_project_name"></a> [watsonx\_project\_name](#input\_watsonx\_project\_name) | Name of the watson project to create. | `string` | `"demo"` | no |
| <a name="input_watsonx_project_tags"></a> [watsonx\_project\_tags](#input\_watsonx\_project\_tags) | Tags to attach to the watson project to create. | `list(string)` | <pre>[<br>  "watsonx-ai-SaaS"<br>]</pre> | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | ID of the resource group used to provision the resources |
| <a name="output_watson_governance_crn"></a> [watson\_governance\_crn](#output\_watson\_governance\_crn) | CRN of the Watson Governance instance |
| <a name="output_watson_governance_dashboard_url"></a> [watson\_governance\_dashboard\_url](#output\_watson\_governance\_dashboard\_url) | Dashboard URL of the Watson Governance instance |
| <a name="output_watson_governance_guid"></a> [watson\_governance\_guid](#output\_watson\_governance\_guid) | GUID of the Watson Governance instance |
| <a name="output_watson_governance_name"></a> [watson\_governance\_name](#output\_watson\_governance\_name) | Name of the Watson Governance instance |
| <a name="output_watson_governance_plan_id"></a> [watson\_governance\_plan\_id](#output\_watson\_governance\_plan\_id) | Plan ID of the Watson Governance instance |
| <a name="output_watson_machine_learning_crn"></a> [watson\_machine\_learning\_crn](#output\_watson\_machine\_learning\_crn) | CRN of the Watson Machine Learning instance |
| <a name="output_watson_machine_learning_dashboard_url"></a> [watson\_machine\_learning\_dashboard\_url](#output\_watson\_machine\_learning\_dashboard\_url) | Dashboard URL of the Watson Machine Learning instance |
| <a name="output_watson_machine_learning_guid"></a> [watson\_machine\_learning\_guid](#output\_watson\_machine\_learning\_guid) | GUID of the Watson Machine Learning instance |
| <a name="output_watson_machine_learning_name"></a> [watson\_machine\_learning\_name](#output\_watson\_machine\_learning\_name) | Name of the Watson Machine Learning instance |
| <a name="output_watson_machine_learning_plan_id"></a> [watson\_machine\_learning\_plan\_id](#output\_watson\_machine\_learning\_plan\_id) | Plan ID of the Watson Machine Learning instance |
| <a name="output_watson_platform_endpoint"></a> [watson\_platform\_endpoint](#output\_watson\_platform\_endpoint) | Endpoint of the Watson platform |
| <a name="output_watson_studio_crn"></a> [watson\_studio\_crn](#output\_watson\_studio\_crn) | CRN of the Watson Studio instance |
| <a name="output_watson_studio_dashboard_url"></a> [watson\_studio\_dashboard\_url](#output\_watson\_studio\_dashboard\_url) | Dashboard URL of the Watson Studio instance |
| <a name="output_watson_studio_guid"></a> [watson\_studio\_guid](#output\_watson\_studio\_guid) | GUID of the Watson Studio instance |
| <a name="output_watson_studio_name"></a> [watson\_studio\_name](#output\_watson\_studio\_name) | Name of the Watson Studio instance |
| <a name="output_watson_studio_plan_id"></a> [watson\_studio\_plan\_id](#output\_watson\_studio\_plan\_id) | Plan ID of the Watson Studio instance |
| <a name="output_watsonx_assistant_crn"></a> [watsonx\_assistant\_crn](#output\_watsonx\_assistant\_crn) | CRN of the WatsonX Assistant instance |
| <a name="output_watsonx_assistant_dashboard_url"></a> [watsonx\_assistant\_dashboard\_url](#output\_watsonx\_assistant\_dashboard\_url) | Dashboard URL of the WatsonX Assistant instance |
| <a name="output_watsonx_assistant_guid"></a> [watsonx\_assistant\_guid](#output\_watsonx\_assistant\_guid) | GUID of the WatsonX Assistant instance |
| <a name="output_watsonx_assistant_name"></a> [watsonx\_assistant\_name](#output\_watsonx\_assistant\_name) | Name of the WatsonX Assistant instance |
| <a name="output_watsonx_assistant_plan_id"></a> [watsonx\_assistant\_plan\_id](#output\_watsonx\_assistant\_plan\_id) | Plan ID of the WatsonX Assistant instance |
| <a name="output_watsonx_discovery_crn"></a> [watsonx\_discovery\_crn](#output\_watsonx\_discovery\_crn) | CRN of the WatsonX Discovery instance |
| <a name="output_watsonx_discovery_dashboard_url"></a> [watsonx\_discovery\_dashboard\_url](#output\_watsonx\_discovery\_dashboard\_url) | Dashboard URL of the WatsonX Discovery instance |
| <a name="output_watsonx_discovery_guid"></a> [watsonx\_discovery\_guid](#output\_watsonx\_discovery\_guid) | GUID of the WatsonX Discovery instance |
| <a name="output_watsonx_discovery_name"></a> [watsonx\_discovery\_name](#output\_watsonx\_discovery\_name) | Name of the WatsonX Discovery instance |
| <a name="output_watsonx_discovery_plan_id"></a> [watsonx\_discovery\_plan\_id](#output\_watsonx\_discovery\_plan\_id) | Plan ID of the WatsonX Discovery instance |
| <a name="output_watsonx_project_id"></a> [watsonx\_project\_id](#output\_watsonx\_project\_id) | ID of the created watsonx project |
| <a name="output_watsonx_project_location"></a> [watsonx\_project\_location](#output\_watsonx\_project\_location) | location of the created watsonx project |
| <a name="output_watsonx_project_url"></a> [watsonx\_project\_url](#output\_watsonx\_project\_url) | URL of the created project |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
