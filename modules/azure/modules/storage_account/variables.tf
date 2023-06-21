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

variable "static_website" {
  type = object({
    index_document     = string
    error_404_document = optional(string)
  })
  description = "Static website settings"
}
