variable "username" {}
variable "password" {}
variable "domain" {}

output "lambda_viewer_request" {
  value = "${aws_lambda_function.basic_auth_lambda.qualified_arn}"
}