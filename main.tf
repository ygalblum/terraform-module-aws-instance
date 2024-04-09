data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_vpc" "current" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  myip_cidr = "${chomp(data.http.myip.response_body)}/32"
  vpc_cidr_block = "${data.aws_vpc.current.cidr_block}"
  security_group_ids = concat(
    [aws_security_group.ssh.id, aws_security_group.outbound.id],
    length(var.application_ports) == 0 ? [] : [aws_security_group.applications[0].id]
  )
}

data "aws_ami" "latest_centos_ami" {
  most_recent = true
  owners = ["125523088429"]
  filter {
    name   = "name"
    values = ["CentOS Stream 9 x86_64*"]
  }
}

resource "aws_instance" "this" {
    tags = {
        Name = var.instance_name
    }

    ami           = data.aws_ami.latest_centos_ami.id
    instance_type = var.instance_type

    key_name = var.ssh_key_name

    vpc_security_group_ids = tolist(local.security_group_ids)

    root_block_device {
      volume_size = var.volume_size
    }
}
