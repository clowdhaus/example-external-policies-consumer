variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Policy
################################################################################

variable "karpenter_version" {
  description = "The version of Karpenter to deploy"
  type        = string
  default     = "v0.28.0"
}
