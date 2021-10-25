provider "aws" {
  region = var.aws_region
}

#terraform {
#  backend "s3" {
#    bucket                      = "gamateam4"
#    key                         = "gamateam4/terraform.tfstate"
#    region                      = "sa-east-1"
#    encrypt                     = true
#    skip_credentials_validation = true
#    skip_metadata_api_check     = true
#  }
#}


