resource "template_dir" "basic_auth_lambda" {
  source_dir      = "${path.module}/lambda/basic_auth_lambda"
  destination_dir = "${path.module}/lambda/basic_auth_lambda.templated"

  vars {
    BASIC_USER = "${var.username}"
    BASIC_PWD  = "${var.password}"
  }
}

data "archive_file" "basic_auth_lambda" {
  depends_on = [
    "template_dir.basic_auth_lambda",
  ]

  type        = "zip"
  output_path = "${path.module}/lambda/basic_auth_lambda.zip"
  source_dir  = "${template_dir.basic_auth_lambda.destination_dir}"
}

resource "aws_lambda_function" "basic_auth_lambda" {
  description = "Basic HTTP authentication function"
  role        = "${aws_iam_role.this.arn}"
  runtime     = "nodejs8.10"

  filename         = "${data.archive_file.basic_auth_lambda.output_path}"
  source_code_hash = "${data.archive_file.basic_auth_lambda.output_base64sha256}"

  function_name = "${var.domain}-lambda-tf"
  handler       = "index.handler"

  timeout     = "3"
  memory_size = "128"
  publish     = true
}
