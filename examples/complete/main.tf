provider "aws" {
  region = "us-east-1"
}

data "aws_kms_key" "efs" {
  key_id = "alias/efs-key"
}

module "efs" {
  source = "../../"

  name                  = "complete-efs"
  vpc_id                = "vpc-0123456789abcdef0"
  subnet_ids            = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1", "subnet-0123456789abcdef2"]
  security_group_ids    = ["sg-0123456789abcdef0"]
  performance_mode      = "generalPurpose"
  throughput_mode       = "provisioned"
  provisioned_throughput = 256
  encrypted             = true
  kms_key_arn           = data.aws_kms_key.efs.arn
  lifecycle_policy      = "AFTER_14_DAYS"

  access_points = {
    app = {
      path = "/app"
      posix_user = {
        gid = 1000
        uid = 1000
      }
      root_directory = {
        path = "/app"
        creation_info = {
          owner_gid   = 1000
          owner_uid   = 1000
          permissions = "755"
        }
      }
    }
    shared = {
      path = "/shared"
      posix_user = {
        gid = 1002
        uid = 1002
        secondary_gids = [1000, 1001]
      }
      root_directory = {
        path = "/shared"
        creation_info = {
          owner_gid   = 1002
          owner_uid   = 1002
          permissions = "775"
        }
      }
    }
  }

  enable_backup                 = true
  enable_replication            = true
  replication_destination_region = "us-west-2"

  tags = {
    Environment = "production"
    Project     = "example"
    CostCenter  = "engineering"
  }
}

output "efs_id" {
  value = module.efs.file_system_id
}

output "efs_arn" {
  value = module.efs.file_system_arn
}

output "efs_dns_name" {
  value = module.efs.file_system_dns_name
}

output "mount_target_ids" {
  value = module.efs.mount_target_ids
}

output "access_point_ids" {
  value = module.efs.access_point_ids
}

output "security_group_id" {
  value = module.efs.security_group_id
}
