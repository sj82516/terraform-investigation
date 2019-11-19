provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

provider "aws" {
  region = "us-west-2"
  alias = "west2"
}

provider "aws" {
  region = "ap-northeast-1"
  alias = "northeast1"
}

locals {
  SLACK_URL = "https://hooks.slack.com/services/......."
}


module "lambda-api-test_us-east-1" {
  source     = "./modules/lambda-api-test"
  providers = {
    aws = aws
  }
  # depends_on = ["aws_iam_role.iam_for_lambda"]

  region                     = "us-east-1"
  lambda_variables-SLACK_URL = local.SLACK_URL
  iam_role_name              = var.lambda_role_name
}

module "lambda-api-test_us-west-2" {
  source     = "./modules/lambda-api-test"
  providers = {
    aws = aws.west2
  }
  # depends_on = ["aws_iam_role.iam_for_lambda"]

  region                     = "us-west-2"
  lambda_variables-SLACK_URL = local.SLACK_URL
  iam_role_name              = var.lambda_role_name
}

module "lambda-api-test_ap-northeast-1" {
  source     = "./modules/lambda-api-test"
  providers = {
    aws = aws.northeast1
  }
  # depends_on = ["aws_iam_role.iam_for_lambda"]

  region                     = "ap-northeast-1"
  lambda_variables-SLACK_URL = local.SLACK_URL
  iam_role_name              = var.lambda_role_name
}