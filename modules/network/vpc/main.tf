
## Create VPC ##

resource "aws_vpc" "vpc_default" {
  cidr_block            = var.vpcCIDRblock
  instance_tenancy      = var.InstanceTenancy
  enable_dns_support    = var.EnableDNS
  enable_dns_hostnames  = var.DnsHostnames

  tags = {
      Name = format("%s-%s", var.project_name, "VPC")
      Project = var.project_name 
      Ambiente = var.ambiente
  }
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = var.DNSresolverDHCP
}

resource "aws_flow_log" "flow_logs_VPC" {
  log_destination      = aws_s3_bucket.bucket_flow.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc_default.id

  depends_on = [ aws_s3_bucket.bucket_flow ]
}

resource "aws_s3_bucket" "bucket_flow" {
  bucket = "team4gama"
  acl    = "private"
}

## Create Private subnets ##

resource "aws_subnet" "subnetprivada" {
    count                       = length(var.availabilityZone)
    vpc_id                      = aws_vpc.vpc_default.id
    cidr_block                  = cidrsubnet(var.vpcCIDRblock, 8, count.index)
    availability_zone           = element(var.availabilityZone, count.index)

    tags = {
      Name = format("%s-%s-%d", var.project_name, "subnet_privada", count.index + 1)
       Project                                          = var.project_name 
       Ambiente                                         = var.ambiente
    }
}

## Create Public Subnets ##

resource "aws_subnet" "subnetpublica" {
    count                       = length(var.availabilityZone)
    vpc_id                      = aws_vpc.vpc_default.id
    cidr_block                  = cidrsubnet(var.vpcCIDRblock, 8, count.index +4)
    map_public_ip_on_launch     = var.mapPublicIP
    availability_zone           = element(var.availabilityZone, count.index)

    tags = {
      Name = format("%s-%s-%d", var.project_name, "subnet_publica", count.index + 1)
       Project                                          = var.project_name 
       Ambiente                                         = var.ambiente 
    }
}

## Create Internet Gateway  ##

resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.vpc_default.id

    tags = {
        Name        = format("%s-%s", "IG_", var.project_name)
        Project     = var.project_name
        Ambiente    = var.ambiente
    }
}

## Create route Table - Internet Gateway ##

resource "aws_route_table" "route_table_IG" {
    vpc_id  = aws_vpc.vpc_default.id
    tags = {
        Name     = format("%s-%s-%s", var.project_name, "Route_Table_IG_", var.project)
        Project  = var.project_name
        Ambiente = var.ambiente
    }
}

## Create route to Route Table - Internet Gateway ##

resource "aws_route" "internet_access_IG" {
    route_table_id         = aws_route_table.route_table_IG.id
    destination_cidr_block = var.destinationCIDRblock 
    gateway_id             = aws_internet_gateway.IG.id 
}

## Association route Table to subnet public ##

resource "aws_route_table_association" "association_subnetpublic" {
  count          = length(var.availabilityZone)
  subnet_id      = element(aws_subnet.subnetpublica.*.id, count.index)
  route_table_id = aws_route_table.route_table_IG.id
}
 
## Creating elastic IP to allocate on NatGateway ##

resource "aws_eip" "eip" {
  count     = length(var.availabilityZone)
  vpc       = var.VPCeip
}

## creating NatGateway to private subnets ##

resource "aws_nat_gateway" "NGPJ2"{
    count         = length(var.availabilityZone)
    allocation_id = element(aws_eip.eip.*.id, count.index)
    subnet_id     = element(aws_subnet.subnetpublica.*.id, count.index)

        tags = {
            Name = format("%s-%s-%d", var.project_name, "NG_subnet", count.index +1)
            Project  = var.project_name
            Ambiente = var.ambiente
            
        }
}

## Creating Route Table to NatGateways ##

resource "aws_route_table" "route_table_NG" {
    count   = length(var.availabilityZone)
    vpc_id  = aws_vpc.vpc_default.id
    tags    = {
        Name = format("%s-%s-%d", var.project_name, "Route_Table_NG", count.index +1)
        Project = var.project_name
        Ambiente = var.ambiente
    }
}

## Create route to Route Table - NatGateway ##

resource "aws_route" "internet_access_NG" {
    count                  = length(var.availabilityZone)
    route_table_id         = element(aws_route_table.route_table_NG.*.id, count.index)
    destination_cidr_block = var.destinationCIDRblock
    nat_gateway_id         = element(aws_nat_gateway.NGPJ2.*.id, count.index)
}

## associating Private Subnets ##

resource "aws_route_table_association" "association_subnet1" {
  count             = length(var.availabilityZone)
  subnet_id         = element(aws_subnet.subnetprivada.*.id, count.index)
  route_table_id    = element(aws_route_table.route_table_NG.*.id, count.index)
}
