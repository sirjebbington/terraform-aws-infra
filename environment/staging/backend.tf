terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket"
    key            = "staging/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}