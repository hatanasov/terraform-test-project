resource "aws_codepipeline" "wl_pipeline" {
  name     = "test-workload-cicd-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.cicd_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "GetSourceCode"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.gh.arn
        FullRepositoryId = "hatanasov/terraform-test-project"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "TerraformPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["PlanArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build-tf-plan.name
      }
    }
  }

  stage {
    name = "ApprovePlan"

    action {
      name            = "ManualApproval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      # input_artifacts = ["PlanArtifact"]
      version         = "1"

      configuration = {
        CustomData = "Review the Terraform plan.out artifact in S3 before approving: s3://${aws_s3_bucket.cicd_artifacts.arn}/PlanArtifact/$CODEBUILD_BUILD_ID/plan.out"
      }
    }
  }
}