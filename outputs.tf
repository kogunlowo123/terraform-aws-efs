output "file_system_id" {
  description = "The ID of the EFS file system."
  value       = aws_efs_file_system.this.id
}

output "file_system_arn" {
  description = "The ARN of the EFS file system."
  value       = aws_efs_file_system.this.arn
}

output "file_system_dns_name" {
  description = "The DNS name for the EFS file system."
  value       = aws_efs_file_system.this.dns_name
}

output "mount_target_ids" {
  description = "Map of subnet ID to mount target ID."
  value       = { for k, v in aws_efs_mount_target.this : k => v.id }
}

output "mount_target_dns_names" {
  description = "Map of subnet ID to mount target DNS name."
  value       = { for k, v in aws_efs_mount_target.this : k => v.dns_name }
}

output "mount_target_network_interface_ids" {
  description = "Map of subnet ID to mount target network interface ID."
  value       = { for k, v in aws_efs_mount_target.this : k => v.network_interface_id }
}

output "access_point_ids" {
  description = "Map of access point key to access point ID."
  value       = { for k, v in aws_efs_access_point.this : k => v.id }
}

output "access_point_arns" {
  description = "Map of access point key to access point ARN."
  value       = { for k, v in aws_efs_access_point.this : k => v.arn }
}

output "security_group_id" {
  description = "The ID of the EFS security group created by this module."
  value       = aws_security_group.efs.id
}

output "security_group_arn" {
  description = "The ARN of the EFS security group created by this module."
  value       = aws_security_group.efs.arn
}
