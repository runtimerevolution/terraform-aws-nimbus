variable "solution_name" {
  type        = string
  description = "Name of the solution"
}

variable "environment" {
  type        = string
  description = "Application environment type"

  validation {
    condition     = contains(["Staging", "Production"], var.environment)
    error_message = "Invalid value. Expected 'Staging' or 'Production'."
  }
}

variable "subnets_ids" {
  type        = list(string)
  description = "List of subnet IDs to host the databases."
}

variable "security_group_id" {
  type        = string
  description = "Security group ID to assign to the database instances"
}

variable "databases" {
  type = list(
    object({
      identifier                      = optional(string)
      allocated_storage               = optional(number)
      max_allocated_storage           = optional(number)
      instance_class                  = optional(string)
      engine                          = string
      engine_version                  = optional(string)
      db_name                         = optional(string)
      username                        = optional(string)
      password                        = optional(string)
      port                            = optional(number)
      multi_az                        = optional(bool)
      backup_retention_period         = optional(number)
      backup_window                   = optional(string)
      maintenance_window              = optional(string)
      deletion_protection             = optional(bool)
      enabled_cloudwatch_logs_exports = optional(list(string))
      storage_encrypted               = optional(bool)
      storage_type                    = optional(string)
      skip_final_snapshot             = optional(bool)
      final_snapshot_identifier       = optional(bool)
      publicly_accessible             = optional(bool)
    })
  )
  description = "Databases instances to deploy."
  default     = []
}


variable "enable_secrets_manager" {
  type        = string
  description = "Specifies if secrets manager should be used to store sensible data."
  default     = "false"
}
