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

# variable "public_subnet_id" {
#   type        = string
#   description = "Private subnet ID to host the application gateway."
# }

# variable "container_app_environment_static_ip_address" {
#   type        = string
#   description = "List of IP Addresses to include in the Backend Address Pool."
# }

# variable "container_apps" {
#   type = list(object({
#     name = string
#     fqdn = string
#     port = number
#   }))
#   description = "Container apps deployed."
#   default     = []
# }
