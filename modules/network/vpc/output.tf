output "VPCID" {
    value = aws_vpc.vpc_default.id
    description = "Id da VPC criada"
}

#output "subnet_id_public" {
#  value = aws_subnet.public.*.id
#}

#output "subnet_id_private" {
#  value = aws_subnet.private.*.id
#}
