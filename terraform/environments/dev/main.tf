module "vpc" {
  source     = "../../modules/vpc"
  cidr_block = "10.0.0.0/16"
  name       = "main-vpc"
}

module "security_group" {
  source = "../../modules/security_group"
  name   = "main-sg"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source            = "../../modules/ec2"
  ami               = "ami-00e89f3f4910f40a1"
  instance_type     = "t2.micro"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
  name              = "main-ec2"
  key_name          = "maxx"
}

# module "asg" {
#   source            = "../../modules/asg"
#   name              = "main-asg"
#   max_size          = 2
#   min_size          = 1
#   desired_capacity  = 1
#   subnets           = [module.vpc.public_subnet_id]
#   launch_configuration = "your-launch-config"
# }