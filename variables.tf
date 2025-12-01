variable "ssh_key_name" {
  type    = string
  default = null
  description = "Name for the SSH key pair. If null and ssh_public_key is provided, Terraform will auto-generate the name."
}

variable "ssh_public_key" {
  type    = string
  default = null
  description = "SSH public key content. If provided, a key pair will be created in AWS. If not provided, ssh_key_name must reference an existing key pair."
}

variable "ami_name" {
  type        = string
  description = "AMI name pattern to search for (e.g., 'CentOS Stream 9 x86_64*')"
}

variable "ami_owner" {
  type        = string
  default     = null
  description = "AWS account ID of the AMI owner. If null, searches all available AMIs."
}

variable "region" {
  type        = string
  description = "AWS region for deploying resources. If not specified, uses the default region from the AWS provider configuration (environment, shared config file, etc.)."
  default     = null
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
