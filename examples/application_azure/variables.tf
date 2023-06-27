variable "solution_name" {
  type        = string
  description = "Name of the solution."
}

variable "environment" {
  type        = string
  description = "Application environment type."
  default     = "Staging"

  validation {
    condition     = contains(["Staging", "Production"], var.environment)
    error_message = "Invalid value. Expected 'Staging' or 'Production'."
  }
}

variable "location" {
  type        = string
  description = "Location where resources must be created."
  default     = "eastus"
}

variable "static_website_settings" {
  type = object({
    index_document     = string
    error_404_document = string
  })
  description = "Static website settings."
  default = {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}

variable "vnet_cidr" {
  type        = string
  description = "The IPv4 CIDR address for the virtual network."
  default     = "10.0.0.0/16"
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
