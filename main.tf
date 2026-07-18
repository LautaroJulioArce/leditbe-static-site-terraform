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



# Busca una política de caché administrada por AWS para optimizar contenido estático.
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}


# Crea la distribución de CloudFront que entregará la landing almacenada en el bucket S3 privado.
resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "s3-landing-page-cuadros-led"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Landing Page LED IT BE"
  default_root_object = "index.html"
#getscm-history-item:c%3A%5CUsers%5CLauta%5CDesktop%5Cleditbe-aws-terraform?%7B%22repositoryId%22%3A%22scm0%22%2C%22historyItemId%22%3A%22361151459f410b21b6de2d274a14c74cb807ed28%22%2C%22historyItemParentId%22%3A%227c482fad21610a7c0a6384a87865fccf6b586bbf%22%2C%22historyItemDisplayId%22%3A%223611514%22%7D y head son los métodos HTTP que se permiten para acceder al contenido de la distribución de CloudFront.
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-landing-page-cuadros-led"
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
