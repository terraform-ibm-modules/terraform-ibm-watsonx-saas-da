output "key_protect_crn" {
  value       = module.key_protect_module.key_protect_crn
  description = "CRN of the Key Protect instance"
}

output "kms_key_crn" {
  value       = module.kms_root_key.crn
  description = "CRN of the KMS key"
}

output "cos_crn" {
  value       = module.cos_module.cos_instance_crn
  description = "CRN of Cloud Object Storage instance"
}
