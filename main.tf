module "modulevpc" {
    source = "./modules/network/vpc/"

    vpc_name         = var.vpcname
    vpcCIDRblock     = var.vpc_cidr_block
    InstanceTenancy  = var.instance_tenancy
    availabilityZone = var.availability_zone
    project_name     = var.project_name
    ambiente	     = var.ambiente
}
