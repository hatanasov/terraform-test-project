variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "terraform_code_directory" {
  description = "The directory of the terraform code"
  type        = string
  default     = "./terraform"

}