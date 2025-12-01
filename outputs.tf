output "external_services_exteranl_dns" {
  description = "External DNS of the instance"
  value = aws_instance.this.public_dns
}

output "instance_architecture" {
  description = "CPU architecture of the selected instance type"
  value       = local.ami_architecture
}

output "aws_region" {
  description = "AWS region where resources are deployed"
  value       = regex("^([a-z]+-[a-z]+-[0-9]+)[a-z]$", aws_instance.this.availability_zone)[0]
}
