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
}


output "repository_url" {
  value = aws_ecr_repository.image
}

##resource "aws_instance" "web" {
##
##  provisioner "local-exec" {
##    command = "docker build ."
##  }
##
##  depends_on = [aws_ecr_repository.frontend]
##}
