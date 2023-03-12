terraform {
  required_providers {
    aws = {
      version = ">= 4.40.0"
    }
    helm = {
      version = ">= 2.7.1"
    }
    kubernetes = {
      version = ">= 2.16.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                   = data.aws_eks_cluster_auth.eks.token
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
  #   command     = "aws"
  # }
}

provider "aws" {
  region = var.aws_region
}