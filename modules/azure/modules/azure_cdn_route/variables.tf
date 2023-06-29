variable "solution_name" {
  type        = string
  description = "Name of the solution."
}

variable "origin_name" {
  type        = string
  description = "Name of the origin"
}

variable "cdn_frontdoor_profile_id" {
  type        = string
  description = "The ID of the Front Door Profile within which this Front Door Origin Group should exist."
}

variable "origin_host_name" {
  type        = string
  description = "The IPv4 address, IPv6 address or Domain name of the Origin."
}

variable "cdn_frontdoor_endpoint_id" {
  type        = string
  description = "The resource ID of the Front Door Endpoint where this Front Door Route should exist."
}

variable "route_forwarding_protocol" {
  type        = string
  description = "The Protocol that will be use when forwarding traffic to backends."

  validation {
    condition     = contains(["HttpOnly", "HttpsOnly", "MatchRequest"], var.route_forwarding_protocol)
    error_message = "Invalid value. Options are 'HttpOnly', 'HttpsOnly', 'MatchRequest'."
  }
}

variable "route_patterns_to_match" {
  type        = list(string)
  description = "The route patterns of the rule."
}
