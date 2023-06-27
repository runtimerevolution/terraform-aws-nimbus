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

variable "private_subnet_id" {
  type        = string
  description = "Private subnet ID to host the environment."
}

variable "containers" {
  type = list(object({
    name   = string
    image  = string
    cpu    = number
    memory = string
    port   = number
  }))
  description = "Container instances to be deployed."
  default     = []
}
