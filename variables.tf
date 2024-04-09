variable "ssh_key_name" {
  type = string
}

variable "instance_name" {
    type = string
}

variable "instance_type" {
    type = string
    default = "g4dn.xlarge"
}

variable "volume_size" {
    type = number
    default = 30
}

variable "ssh_port" {
    type = number
    default = 22
}

variable "application_ports" {
    type = list(number)
    description = "Allow access to these port. Disabled by default"
    default = []
}

variable "limit_additionl_ports" {
    type = bool
    description = "Limit access to the additional port to the provisioning source IP"
    default = false
}
