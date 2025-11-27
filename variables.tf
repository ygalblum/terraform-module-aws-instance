variable "ssh_key_name" {
  type = string
}

variable "instance_name" {
    type = string
}

variable "instance_family" {
    type = string
    default = "t3"
    description = "EC2 instance family (e.g., t3, t3a, m5, c5)"
}

variable "cpu" {
    type = number
    default = 2
    description = "Minimum number of vCPUs required"
}

variable "ram" {
    type = number
    default = 4
    description = "Minimum RAM in GB required"
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
