output "is_storage_delegated" {
  description = "Return if the storage was delegated or not."
  value       = var.cos_kms_crn == null || var.cos_kms_crn == "" ? false : true
}
