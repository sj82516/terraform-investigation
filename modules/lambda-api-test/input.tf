variable "region" {
  type    = string
  default = "us-east-1"
}

variable "iam_role_name" {
  type = string
}


variable "lambda_function_name" {
  type    = string
  default = "global-api-lantency-test"
}

variable "lambda_variables-SLACK_URL" {
  type = string
}


