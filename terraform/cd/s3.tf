resource "aws_s3_bucket" "cicd_artifacts" {
  bucket = "test-workload-cicd-artifacts-${data.aws_caller_identity.current.account_id}"
}
output "artifact_bucket" {
  value = aws_s3_bucket.cicd_artifacts.bucket
}
# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#   bucket = aws_s3_bucket.cicd_artifacts.id
#   policy = templatefile("${path.module}/policies/s3_bucket_policy.json",
#     {
#       BUCKET_ARN            = aws_s3_bucket.cicd_artifacts.arn
#       CODEBUILD_ROLE_ARN    = aws_iam_role.codebuild.arn
#       CODEPIPELINE_ROLE_ARN = aws_iam_role.codepipeline.arn
#     }
#   )
#   depends_on = [aws_codepipeline.wl_pipeline]
# }

resource "aws_s3_bucket_public_access_block" "cicd_artifacts" {
  bucket = aws_s3_bucket.cicd_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#StateBucket

resource "aws_s3_bucket" "tf-states" {
  bucket = "test-workload-tfstate-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tf-states.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}