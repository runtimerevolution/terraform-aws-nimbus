output "static_website_bucket" {
  value = var.enable_static_website ? module.static_website_bucket[0].bucket : null
}
