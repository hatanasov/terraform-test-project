resource "aws_iam_role" "codebuild" {
  name               = "test-workload-cicd-codebuild-role"
  assume_role_policy = file("${path.module}/policies/cicd_deploy_assume_role.json")
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "test-workload-policy-cicd-codebuild"
  role   = aws_iam_role.codebuild.name
  policy = templatefile("${path.module}/policies/cicd_deploy_policy.json", {})
}

resource "aws_iam_role" "codepipeline" {
  name               = "test-workload-cicd-codepipeline-role"
  assume_role_policy = file("${path.module}/policies/cicd_codepipeline_assume_role.json")
}

resource "aws_iam_role_policy" "codepipeline" {
  name = "test-workload-policy-cicd-codepipeline"
  role = aws_iam_role.codepipeline.name
  policy = templatefile("${path.module}/policies/cicd_codepipeline_policy.json",
    {
      BUCKET_ARN = aws_s3_bucket.cicd_artifacts.arn
    }
  )
}