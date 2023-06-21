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

variable "static_website_index_document" {
  type        = string
  description = "The webpage served for requests to the root of the application."
  default     = "index.html"
}

variable "static_website_error_document" {
  type        = string
  description = "The webpage served when the request is not successful."
  default     = "error.html"
}
