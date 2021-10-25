## Variables VPC ##

variable "project_name"{
    type = string
    description = "Project Name"
}

variable "ambiente" {
    type = string
    description = "evironment's service"
}

variable "vpc_name" {
    type = string
    description = "Name VPC"
}

variable "vpcCIDRblock" {
    type = string
}

variable "InstanceTenancy" {
    type = string
}

variable "EnableDNS" {
    type = bool
    default = true
}

variable "DnsHostnames" {
    type = bool
    default = true
}

variable "DNSresolverDHCP" {
    type = list
    default = ["AmazonProvidedDNS"]
}

## Variables Subnets ##

variable "availabilityZone" {
    type = list
    description = "Subnet's availability zones"
}

variable "mapPublicIP" {
    type = bool
    default = true
}

variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}

variable "VPCeip" {
    default = true
}
