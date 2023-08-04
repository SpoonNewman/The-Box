terraform {
  required_providers{
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.10.0"
    }
}
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
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = "vpc-07493c4ef33a2966e"
  subnet_ids               = ["subnet-0b7b0ca7f70b5d4fd", "subnet-08ad9a0639b24a1a1", "subnet-08797671cb04c4e6f"]
  control_plane_subnet_ids = ["subnet-0b7b0ca7f70b5d4fd", "subnet-08ad9a0639b24a1a1", "subnet-08797671cb04c4e6f"]

  eks_managed_node_group_defaults = {
    instance_types = ["t2.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
    project     = "The_Box"
    author      = "Spoon_Newman" 
  }
}

