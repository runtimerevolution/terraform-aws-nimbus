variable "solution_name" {
  type        = string
  description = "Name of the solution."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to host the CDN."
}

variable "resource_group_location" {
  type        = string
  description = "The Azure location where to create the resources."
}

variable "storage_account_kind" {
  type        = string
  description = "Defines the Kind of account."

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.storage_account_kind)
    error_message = "Invalid value. Options are 'BlobStorage', 'BlockBlobStorage', 'FileStorage', 'Storage', 'StorageV2'."
  }
}

variable "storage_account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account."

  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "Invalid value. Options are 'Standard', 'Premium'."
  }
}

variable "storage_account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account."

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "Invalid value. Options are 'LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', 'RAGZRS'."
  }
}

variable "static_website_settings" {
  type = object({
    index_document     = string
    error_404_document = string
  })
  description = "Static website settings."
}
