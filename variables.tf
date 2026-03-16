variable "name" {
  description = "Name of the EFS file system."
  type        = string
}

variable "performance_mode" {
  description = "The file system performance mode (generalPurpose or maxIO)."
  type        = string
  default     = "generalPurpose"

  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.performance_mode)
    error_message = "Valid values for performance_mode are 'generalPurpose' or 'maxIO'."
  }
}

variable "throughput_mode" {
  description = "Throughput mode for the file system (bursting, provisioned, or elastic)."
  type        = string
  default     = "bursting"

  validation {
    condition     = contains(["bursting", "provisioned", "elastic"], var.throughput_mode)
    error_message = "Valid values for throughput_mode are 'bursting', 'provisioned', or 'elastic'."
  }
}

variable "provisioned_throughput" {
  description = "Throughput in MiB/s to provision; only applicable when throughput_mode is provisioned."
  type        = number
  default     = null
}

variable "encrypted" {
  description = "Whether to enable encryption at rest for the EFS file system."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for encryption; uses AWS-managed key if not specified."
  type        = string
  default     = null
}

variable "lifecycle_policy" {
  description = "Lifecycle policy for transitioning files to IA storage (e.g. AFTER_30_DAYS)."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for EFS mount targets."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of additional security group IDs to attach to mount targets."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID where the EFS file system and security group will be created."
  type        = string
}

variable "access_points" {
  description = "Map of access point configurations to create."
  type = map(object({
    posix_user = optional(object({
      gid            = number
      uid            = number
      secondary_gids = optional(list(number), [])
    }))
    root_directory = optional(object({
      path = optional(string, "/")
      creation_info = optional(object({
        owner_gid   = number
        owner_uid   = number
        permissions = string
      }))
    }))
    path = optional(string)
  }))
  default = {}
}

variable "enable_backup" {
  description = "Whether to enable automatic backups for the EFS file system."
  type        = bool
  default     = true
}

variable "enable_replication" {
  description = "Whether to enable EFS replication to another region."
  type        = bool
  default     = false
}

variable "replication_destination_region" {
  description = "AWS region for the EFS replication destination."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
