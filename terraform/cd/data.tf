data "aws_caller_identity" "current" {}

data "aws_codestarconnections_connection" "gh" {
  name = "cicd-image-factory-repo"
}

output "connection" {
  value = data.aws_codestarconnections_connection.gh.arn
}