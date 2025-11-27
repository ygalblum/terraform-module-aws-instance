output "external_services_exteranl_dns" {
  description = "External DNS of the instance"
  value = aws_instance.this.public_dns
}

output "instance_architecture" {
  description = "CPU architecture of the selected instance type"
  value       = local.ami_architecture
}
