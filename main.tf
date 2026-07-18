provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "cuadros-led-terraform-lauta-2026"
}