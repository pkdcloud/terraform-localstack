# main.tf

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "this" {
  name        = var.name
  path        = "/"
  description = "My test policy"
  policy      = var.policy
}

resource "aws_iam_policy_attachment" "this" {
  name       = var.name
  roles      = [aws_iam_role.this.name]
  policy_arn = aws_iam_policy.this.arn
}
