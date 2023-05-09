variable "enable_docker" {
  type = bool
  default = false
}

variable "image_name" {
  type        = string
  default     = "nginx"
}

variable "container_name" {
  type        = string
  default     = "nginx"
}