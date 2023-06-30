output "databases_endpoints" {
  value       = [for i in aws_db_instance.instance : i.endpoint]
  description = "Databases URLs."
}
