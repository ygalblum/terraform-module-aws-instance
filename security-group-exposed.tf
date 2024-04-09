resource "aws_security_group" "applications" {
  count = length(var.application_ports) == 0 ? 0 : 1

  name = "${var.instance_name} - Application ports"
  description = "Security group for Application Ports for ${var.instance_name}"
}

resource "aws_vpc_security_group_ingress_rule" "applications" {
  count = length(var.application_ports)

  security_group_id = aws_security_group.applications[0].id

  ip_protocol = "tcp"
  from_port = var.application_ports[count.index]
  to_port = var.application_ports[count.index]
  cidr_ipv4 = var.limit_additionl_ports ? local.myip_cidr : "0.0.0.0/0"
}
