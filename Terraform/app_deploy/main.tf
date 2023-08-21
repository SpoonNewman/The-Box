terraform{
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.10.0"
        }
        kubernetes = {
          source = "hashicorp/kubernetes"
          version = ">= 2.16.1"
        }
    }
    # backend "s3" {
    #   bucket                  = "terraform-20230725214213457900000001"
    #   key                     = "github_actions_terraform_ci_state"
    #   region                  = "us-east-2"
    # }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket                  = "terraform-20230725214213457900000001"
    key                     = "github_actions_terraform_ci_state"
    region                  = "us-east-2"
  }
}

# Retrieve EKS cluster information
provider "aws" {
  region = data.terraform_remote_state.eks.outputs.region
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

resource "kubernetes_deployment" "flask_api" {
  metadata {
    name      = "flask-api"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "TheBoxApi"
      }
    }
    template {
      metadata {
        labels = {
          app = "TheBoxApi"
        }
      }
      spec {
        container {
          image = "frankycatnewman/theboxapi"
          name  = "flask-api-container"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask_api" {
  metadata {
    name      = "flask-api"
  }
  spec {
    selector = {
      app = kubernetes_deployment.flask_api.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 5000
      target_port = 5000
    }
  }
}