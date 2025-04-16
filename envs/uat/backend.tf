terraform {
  backend "s3" {
    bucket         = "weconnect-terraform-state-uat"     # your backend bucket name
    key            = "uat/terraform.tfstate"              # path inside the bucket
    region         = "ap-south-1"
    encrypt        = true
  }
}
