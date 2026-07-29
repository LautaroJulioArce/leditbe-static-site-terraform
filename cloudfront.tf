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

  # GET y HEAD son los métodos HTTP permitidos para consultar el contenido.

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