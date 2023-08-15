terraform{
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.10.0"
        }
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