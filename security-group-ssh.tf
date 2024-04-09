resource "aws_security_group" "ssh" {
  name = "${var.instance_name} - SSH"
  description = "Security group for SSH to ${var.instance_name}"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ssh.id

  ip_protocol = "tcp"
  from_port = var.ssh_port
  to_port = var.ssh_port
  cidr_ipv4 = local.myip_cidr
}
