## Variables to autentication ##

variable "aws_region" {
  type        = string
  description = "Used AWS Region."
}

## Variables VPC ##

variable "vpcname" {
    type = string
    description = "Name VPC"
}

variable "vpc_cidr_block" {
    description = " IP address range"
}

variable "instance_tenancy" {
    description = "Instance Tenancy Type"
}

variable "availability_zone" {
    type = list
    description = "Subnet's availability zones"
}

variable "project_name" {
  type = string
  description = "Project Name"
}

variable "ambiente" {
  type = string
  description = "Environment's service"
}