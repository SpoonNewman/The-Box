terraform {
  backend "s3" {
    bucket                  = "terraform-20230725214213457900000001"
    key                     = "github_actions_terraform_ci_state"
    region                  = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"

}


resource "aws_sns_topic" "user_updates" {
  name = "universal_topic"
}

resource "aws_cloudwatch_log_group" "yada" {
  name = "universal_cloudwatch_logs"
}


resource "aws_kms_key" "bucket_key" {
  
    description             = "basic utility key"
    deletion_window_in_days = 10
}