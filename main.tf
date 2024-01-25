data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.name
}

data "http" "this" {
  count = var.create ? 1 : 0

  url = "https://raw.githubusercontent.com/clowdhaus/example-external-policies/${var.karpenter_version}/policy/policy.json"
}

data "template_file" "this" {
  count = var.create ? 1 : 0

  template = data.http.this[0].response_body
  vars = {
    "AWS::Partition"              = local.partition
    "AWS::Region"                 = local.region
    ClusterName                   = "Example"
    ClusterArn                    = "arn:${local.partition}:eks:${local.region}:${local.account_id}:cluster/Example"
    KarpenterNodeRoleArn          = "arn:${local.partition}:iam::${local.account_id}:role/KarpenterNodeRole-Example"
    KarpenterInterruptionQueueArn = "arn:${local.partition}:sqs:${local.region}:${local.account_id}:Example"
  }
}

################################################################################
# Policy
################################################################################

resource "aws_iam_policy" "this" {
  count = var.create ? 1 : 0

  name_prefix = "KarpenterNode-"
  description = "Karpenter controller node IAM role"

  policy = data.template_file.this[0].rendered

  tags = var.tags
}
