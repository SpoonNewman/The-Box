terraform{
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.10.0"
        }
    }
}



variable "endpoint" {
    type = string
    description = "EKS Cluster Endpoint"
}

variable "cluster_name" {
  type = string
  description = "Name of the EKS Cluster"
}

variable "cluster_ca" {
    type = string
    description = "The certificate CA of the cluster"
}


provider "kubernetes" {
  host                   = var.endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      var.cluster_name
    ]
  }
}


resource "kubernetes_namespace" "flask_api" {
  metadata {
    name = "flask-api"
  }
}

resource "kubernetes_deployment" "flask_api" {
  metadata {
    name      = "flask-api"
    namespace = kubernetes_namespace.flask_api.metadata.0.name
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
    namespace = kubernetes_namespace.flask_api.metadata.0.name
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