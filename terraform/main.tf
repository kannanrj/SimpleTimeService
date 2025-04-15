provider "aws" {
  region = var.region
  profile = "testinguser"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  region          = var.region
}

module "ecs" {
  source = "./modules/ecs"

  cluster_name     = var.cluster_name
  container_image  = var.container_image
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  public_subnets   = module.vpc.public_subnets
}
