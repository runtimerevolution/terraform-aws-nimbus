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

variable "server_name" {
  type = string
}

variable "server_administrator_login" {
  type = string
}

variable "server_administrator_login_password" {
  type = string
}

variable "server_version" {
  type = string
}

variable "server_databases" {
  type = list(
    object({
      name                                = optional(string)
      collation                           = optional(string)
      license_type                        = optional(string)
      maintenance_configuration_name      = optional(string)
      max_size_gb                         = optional(number)
      sku_name                            = optional(string)
      storage_account_type                = optional(string)
      transparent_data_encryption_enabled = optional(bool)
    })
  )
  description = "Databases to deploy."
}
