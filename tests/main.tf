terraform {
  required_version = ">= 1.7.0"
}

module "test" {
  source = "../"

  name       = "test-efs"
  vpc_id     = "vpc-0123456789abcdef0"
  subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]

  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  enable_backup    = true

  tags = {
    Environment = "test"
    Module      = "terraform-aws-efs"
  }
}
