# Muestra la URL pública de la landing generada por CloudFront.
output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.website.domain_name}"
}