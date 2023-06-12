output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the network VPC."
}

output "public_subnets_ids" {
  value       = aws_subnet.public.*.id
  description = "IDs of the network public subnets."
}

output "private_subnets_ids" {
  value       = aws_subnet.private.*.id
  description = "IDs of the network private subnets."
}

output "security_group_id" {
  value       = aws_security_group.security_group.id
  description = "ID of the network main security group."
}
