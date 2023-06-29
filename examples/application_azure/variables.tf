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

variable "enable_static_website" {
  type        = bool
  description = "Enables/disables serving a static website hosted in a Storage Account."
  default     = false
}

variable "enable_application" {
  type        = bool
  description = "Enables/disables serving application(s) using Container Apps to host containers."
  default     = false
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

variable "cdn_application_patterns_to_match" {
  type        = list(string)
  description = "The path patterns to redirect to the application gateway."
  default     = ["/*"]
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
