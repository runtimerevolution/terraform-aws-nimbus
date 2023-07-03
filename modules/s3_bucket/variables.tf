variable "bucket_name" {
  type        = string
  description = "Name of the bucket."
}

variable "bucket_acl" {
  type        = string
  description = "ACL to assign to the bucket."
}

variable "bucket_policy_json" {
  type        = string
  description = "JSON describing the AWS IAM policy to attach to the bucket."
}
