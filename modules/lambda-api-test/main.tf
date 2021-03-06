data "aws_iam_role" "iam_for_lambda"{
  name = var.iam_role_name
}

resource "aws_lambda_layer_version" "lambda-layer_fetch" {
  filename   = "${path.module}/lambda_layer_payload.zip"
  layer_name = "lambda_layer_name"

  source_code_hash    = "${filebase64sha256("${path.module}/lambda_layer_payload.zip")}"
  compatible_runtimes = ["nodejs10.x"]
}

resource "aws_lambda_function" "lambda_main" {
  function_name = var.lambda_function_name
  filename      = "${path.module}/lambda_payload.zip"
  handler       = "index.handler"
  runtime       = "nodejs10.x"
  role          = "${data.aws_iam_role.iam_for_lambda.arn}"

  source_code_hash = "${filebase64sha256("${path.module}/lambda_payload.zip")}"
  layers = [ 
    "${aws_lambda_layer_version.lambda-layer_fetch.arn}"
  ]
  publish = true
  environment {
    variables = {
      REGION    = var.region
      SLACK_URL = var.lambda_variables-SLACK_URL
    }
  }
}

# add cloudwatch event
resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name        = "routine-api-request"
  description = "Routinely call global api lantency test"

  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "api_request" {
  rule      = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
  target_id = "CallApiRequest"
  arn       = "${aws_lambda_function.lambda_main.arn}"
}

# 
resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_api" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_main.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_five_minutes.arn}"
}
