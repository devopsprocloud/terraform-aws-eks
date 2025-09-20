module "roboshop_vpc" {
  source = "git::https://github.com/devopsprocloud/terraform-vpc-module.git?ref=main"
  vpc_cidr = var.vpc_cidr
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags

  # public_subnet 
  public_subnets_cidr = var.public_subnets_cidr
  # private_subnet 
  private_subnets_cidr = var.private_subnets_cidr
  # database_subnet 
  database_subnets_cidr = var.database_subnets_cidr

  #peering 
  is_peering_required = var.is_peering_required
}