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
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Permite que solamente esta distribución de CloudFront lea los archivos del bucket S3 privado.
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowCloudFrontReadAccess"
        Effect = "Allow"

        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })
}