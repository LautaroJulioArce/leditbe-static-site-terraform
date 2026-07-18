provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "landing-page-cuadros-led-lautaro"

  tags = {
    Name        = "Landing Page LED IT BE"
    Environment = "dev"
    Project     = "leditbe-terraform"
    ManagedBy   = "Terraform"
    Owner       = "Lautaro"
    Purpose     = "Static website"
  }

}



# Mantiene el bucket privado y bloquea el acceso público no autorizado.
# Más adelante se creará un OAC (Origin Access Control) para permitir que CloudFront acceda al bucket de forma segura.
# ACL significa Access Control List.

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}



# Crea un OAC (Origin Access Control) para que CloudFront pueda acceder de forma segura al bucket S3 privado.
# Las solicitudes de CloudFront se firman utilizando AWS Signature Version 4 (SigV4).

resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "landing-page-cuadros-led-lautaro"
  description                       = "Acceso seguro de CloudFront al bucket S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}