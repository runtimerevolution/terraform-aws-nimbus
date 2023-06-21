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
  default = {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}
