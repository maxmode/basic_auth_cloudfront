data "aws_iam_policy_document" "sts" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "lambda:GetFunction",
    ]

    resources = [
      "${aws_lambda_function.basic_auth_lambda.arn}:*",
    ]
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.domain}-basic-auth-policy"
  role   = "${aws_iam_role.this.id}"
  policy = "${data.aws_iam_policy_document.this.json}"
}

resource "aws_iam_role" "this" {
  name               = "${var.domain}-basic-auth-role"
  assume_role_policy = "${data.aws_iam_policy_document.sts.json}"
}
