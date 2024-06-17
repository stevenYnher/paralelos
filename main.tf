
provider "aws"{
    region = "us-east-2"
    profile = "personal"

}

variable "bucket_name" {
  description = "The desired name for your Terraform state bucket"
}

resource "aws_s3_bucket" "frontend" {
  bucket = "nestjs-frontend-bucket"
  act = "public-read"
  website {
    index_document = "index.html"
  }
}

provider "google" {
  project     = var.project_id
  credentials = file(Users/steven/Downloads/fast-gateway-208415-62bc259c13c8.json)
  region      = "us-central1"
}

resource "google_storage_bucket" "terraform_state_bucket" {
  name          = var.bucket_name
  location      = "us-central1"
  force_destroy = true
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}

resource "kubernetes_deployment" "nestjs-demo" {
  metadata {
    name = "backend"
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        container {
          image = "eseynoa/nestjs-demo:latest"
          name  = "backend"
          port {
            container_port = 3000
          }
          env {
            name  = "MONGODB_URI"
            value = "mongodb+srv://joshue10:07128124@cluster0.vtcx6zh.mongodb.net/"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nestjs-demo" {
  metadata {
    name = "backend"
  }
  spec {
    selector = {
      app = "backend"
    }
    port {
      protocol = "TCP"
      port     = 80
      target_port = 3000
    }
  }
}

resource "kubernetes_deployment" "nestjs-bff" {
  metadata {
    name = "bff"
    labels = {
      app = "bff"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "bff"
      }
    }
    template {
      metadata {
        labels = {
          app = "bff"
        }
      }
      spec {
        container {
          image = "eseynoa/nestjs-bff:latest"
          name  = "bff"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nestjs-bff" {
  metadata {
    name = "bff"
  }
  spec {
    selector = {
      app = "bff"
    }
    port {
      protocol = "TCP"
      port     = 80
      target_port = 3000
    }
  }
}

output "kubernetes_cluster_name" {
  value = google_container_cluster.primary.name
}

output "kubernetes_cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "kubernetes_cluster_ca_certificate" {
  value = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

output "kubernetes_admin_username" {
  value = google_container_cluster.primary.master_auth.0.username
}

output "kubernetes_admin_password" {
  value = google_container_cluster.primary.master_auth.0.password
}
