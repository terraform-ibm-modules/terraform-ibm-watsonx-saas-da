module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.6"
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

module "key_protect_module" {
  source            = "terraform-ibm-modules/key-protect/ibm"
  version           = "2.8.8"
  key_protect_name  = "${var.prefix}-kp"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  tags              = var.resource_tags
  access_tags       = var.access_tags
}

module "kms_root_key" {
  source          = "terraform-ibm-modules/kms-key/ibm"
  version         = "1.2.4"
  kms_instance_id = module.key_protect_module.key_protect_id
  key_name        = "test-r-key"
}
