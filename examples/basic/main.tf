provider "aws" {
  region = "us-east-1"
}

module "efs" {
  source = "../../"

  name       = "basic-efs"
  vpc_id     = "vpc-0123456789abcdef0"
  subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}

output "efs_id" {
  value = module.efs.file_system_id
}

output "efs_dns_name" {
  value = module.efs.file_system_dns_name
}
