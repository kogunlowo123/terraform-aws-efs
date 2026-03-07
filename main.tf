###############################################################################
# EFS File System
###############################################################################

resource "aws_efs_file_system" "this" {
  creation_token   = var.name
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  encrypted        = var.encrypted
  kms_key_id       = var.kms_key_arn

  provisioned_throughput_in_mibps = var.throughput_mode == "provisioned" ? var.provisioned_throughput : null

  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy != null ? [var.lifecycle_policy] : []

    content {
      transition_to_ia = lifecycle_policy.value
    }
  }

  tags = local.common_tags
}

###############################################################################
# Security Group for NFS
###############################################################################

resource "aws_security_group" "efs" {
  name        = "${var.name}-efs"
  description = "Security group for EFS mount targets - ${var.name}"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    "Name" = "${var.name}-efs"
  })
}

resource "aws_security_group_rule" "nfs_ingress" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.this.cidr_block]
  security_group_id = aws_security_group.efs.id
  description       = "Allow NFS traffic from VPC CIDR"
}

resource "aws_security_group_rule" "nfs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.efs.id
  description       = "Allow all outbound traffic"
}

###############################################################################
# Mount Targets (one per subnet)
###############################################################################

resource "aws_efs_mount_target" "this" {
  for_each = toset(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = local.security_group_ids
}

###############################################################################
# Access Points
###############################################################################

resource "aws_efs_access_point" "this" {
  for_each = var.access_points

  file_system_id = aws_efs_file_system.this.id

  dynamic "posix_user" {
    for_each = each.value.posix_user != null ? [each.value.posix_user] : []

    content {
      gid            = posix_user.value.gid
      uid            = posix_user.value.uid
      secondary_gids = posix_user.value.secondary_gids
    }
  }

  root_directory {
    path = each.value.path != null ? each.value.path : try(each.value.root_directory.path, "/")

    dynamic "creation_info" {
      for_each = try(each.value.root_directory.creation_info, null) != null ? [each.value.root_directory.creation_info] : []

      content {
        owner_gid   = creation_info.value.owner_gid
        owner_uid   = creation_info.value.owner_uid
        permissions = creation_info.value.permissions
      }
    }
  }

  tags = merge(local.common_tags, {
    "Name" = "${var.name}-${each.key}"
  })
}

###############################################################################
# Backup Policy
###############################################################################

resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = var.enable_backup ? "ENABLED" : "DISABLED"
  }
}

###############################################################################
# Replication Configuration
###############################################################################

resource "aws_efs_replication_configuration" "this" {
  count = var.enable_replication ? 1 : 0

  source_file_system_id = aws_efs_file_system.this.id

  destination {
    region = var.replication_destination_region
  }
}
