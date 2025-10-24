##############################################################################################################
# RESOURCE GROUP
##############################################################################################################
module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.4.0"
  existing_resource_group_name = var.existing_resource_group_name
}

##############################################################################################################
# KMS
##############################################################################################################

module "key_protect_module" {
  source            = "terraform-ibm-modules/key-protect/ibm"
  version           = "2.10.2"
  key_protect_name  = "${var.prefix}-kp"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  tags              = var.resource_tags
  access_tags       = var.access_tags
  allowed_network   = "public-and-private"
}

module "kms_root_key" {
  source          = "terraform-ibm-modules/kms-key/ibm"
  version         = "1.4.0"
  kms_instance_id = module.key_protect_module.key_protect_id
  key_name        = "test-r-key"
}

##############################################################################################################
# Cloud Object Storage
##############################################################################################################

module "cos_module" {
  source                     = "terraform-ibm-modules/cos/ibm"
  version                    = "10.4.0"
  resource_group_id          = module.resource_group.resource_group_id
  region                     = var.region
  cos_instance_name          = "${var.prefix}-cos"
  existing_kms_instance_guid = module.key_protect_module.key_protect_guid
  create_cos_bucket          = false
}

##############################################################################################################
