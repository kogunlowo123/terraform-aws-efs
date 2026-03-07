locals {
  common_tags = merge(
    {
      "Name"      = var.name
      "ManagedBy" = "terraform"
      "Module"    = "terraform-aws-efs"
    },
    var.tags
  )

  security_group_ids = concat([aws_security_group.efs.id], var.security_group_ids)
}
