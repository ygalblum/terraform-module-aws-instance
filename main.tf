data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_vpc" "current" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ec2_instance_types" "matching" {
  filter {
    name   = "instance-type"
    values = ["${var.instance_family}.*"]
  }

  filter {
    name   = "vcpu-info.default-vcpus"
    values = [for i in range(var.cpu, 257) : tostring(i)]
  }
}

data "aws_ec2_instance_type" "matched_types" {
  for_each = toset(data.aws_ec2_instance_types.matching.instance_types)

  instance_type = each.key
}

resource "aws_key_pair" "this" {
  count = var.ssh_public_key != null ? 1 : 0

  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key

  tags = {
    Name = var.instance_name
  }
}

locals {
  myip_cidr = "${chomp(data.http.myip.response_body)}/32"
  vpc_cidr_block = "${data.aws_vpc.current.cidr_block}"
  security_group_ids = concat(
    [aws_security_group.ssh.id, aws_security_group.outbound.id],
    length(var.application_ports) == 0 ? [] : [aws_security_group.applications[0].id]
  )

  # Sort matching instance types by memory (smallest first), then by vcpus
  sorted_instances = [
    for type_name, type_data in data.aws_ec2_instance_type.matched_types : {
      name   = type_name
      vcpus  = type_data.default_vcpus
      memory = type_data.memory_size
    }
    if type_data.memory_size >= var.ram * 1024
  ]

  sorted_by_size = sort([
    for inst in local.sorted_instances :
    format("%020d-%020d-%s", inst.memory, inst.vcpus, inst.name)
  ])

  # Select the smallest matching instance type
  instance_type = length(local.sorted_by_size) > 0 ? split("-", local.sorted_by_size[0])[2] : null

  # Use created key pair name if available, otherwise use provided ssh_key_name
  ssh_key_name = length(aws_key_pair.this) > 0 ? aws_key_pair.this[0].key_name : var.ssh_key_name
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
    instance_type = local.instance_type

    key_name = local.ssh_key_name

    vpc_security_group_ids = tolist(local.security_group_ids)

    root_block_device {
      volume_size = var.volume_size
    }

    lifecycle {
        precondition {
            condition     = local.instance_type != null
            error_message = "No instance type in family '${var.instance_family}' meets the requirements of ${var.cpu} vCPUs and ${var.ram} GB RAM. Please adjust your requirements or choose a different instance family."
        }
    }
}
