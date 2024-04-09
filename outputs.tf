output "external_services_exteranl_dns" {
  description = "External DNS of the instance"
  value = aws_instance.this.public_dns
}
