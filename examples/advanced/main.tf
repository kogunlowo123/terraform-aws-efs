provider "aws" {
  region = "us-east-1"
}

module "efs" {
  source = "../../"

  name             = "advanced-efs"
  vpc_id           = "vpc-0123456789abcdef0"
  subnet_ids       = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"
  encrypted        = true
  lifecycle_policy = "AFTER_30_DAYS"

  access_points = {
    data = {
      path = "/data"
      posix_user = {
        gid = 1000
        uid = 1000
      }
      root_directory = {
        path = "/data"
        creation_info = {
          owner_gid   = 1000
          owner_uid   = 1000
          permissions = "755"
        }
      }
    }
    logs = {
      path = "/logs"
      posix_user = {
        gid = 1001
        uid = 1001
      }
      root_directory = {
        path = "/logs"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "750"
        }
      }
    }
  }

  enable_backup = true

  tags = {
    Environment = "staging"
    Project     = "example"
  }
}

output "efs_id" {
  value = module.efs.file_system_id
}

output "access_point_ids" {
  value = module.efs.access_point_ids
}
