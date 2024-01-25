provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "external-policies-ex-${basename(path.cwd)}"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/clowdhaus/terraform-aws-external-policies"
  }
}

################################################################################
# external policies Module
################################################################################

module "external_policies" {
  source = "../.."

  create = false

  tags = local.tags
}

module "external_policies_disabled" {
  source = "../.."

  create = false
}
