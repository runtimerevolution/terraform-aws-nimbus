variable "subnets_ids" {
  type        = list(string)
  description = "List of subnet IDs to host the databases."
}

variable "security_group_id" {
  type        = string
  description = "Security group ID to assign to the database instances"
}

variable "databases" {
  type        = any
  description = "Databases instances to deploy."
}
