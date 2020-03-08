variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "cluster_name" {
  default = "terraform-eks-demo"
  type    = string
}

variable "aws_region" {
  default = "us-west-2"
  type    = string
}


provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


resource "aws_ecr_repository" "image" {
  name                 = "image-to-remove"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  provisioner "local-exec" {
    command = "docker build -t $REPO_URL ./backend && docker push $REPO_URL"
    environment = {
      REPO_URL = aws_ecr_repository.image.repository_url
    }
  }
}

resource "null_resource" "image" {
  provisioner "local-exec" {
    command = "docker build -t $REPO_URL ./backend && docker push $REPO_URL"
    environment = {
      REPO_URL = aws_ecr_repository.image.repository_url
    }
  }
  triggers = {
    build_number = "${timestamp()}"
  }
}

output "repository_url" {
  value = "docker build -t ${aws_ecr_repository.image.repository_url} ./backend && docker push ${aws_ecr_repository.image.repository_url}"
}
