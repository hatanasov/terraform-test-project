resource "aws_codebuild_project" "build-tf-plan" {
  name          = "test-workload-build-tf-plan"
  description   = "Terraform codebuild project"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "980859860798.dkr.ecr.eu-west-1.amazonaws.com/cicd_images:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    privileged_mode             = true

    environment_variable {
      name  = "TF_PLAN_FILE"
      value = "plan.out"
    }
    environment_variable {
      name  = "TF_STATE_BUCKET"
      value = aws_s3_bucket.tf-states.bucket
    }
    environment_variable {
      name  = "TF_REGION"
      value = var.aws_region
    }
    environment_variable {
      name  = "TF_CODE_DIR"
      value = var.terraform_code_directory
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "terraform/cd/buildspec.yaml"
  }
}