provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "landing-page-cuadros-led-lautaro"
}


#esto hace que el bucket sea privado y no pueda ser accedido por nadie. 
#ni siquiera por el dueño del bucket. Esto es importante para evitar que alguien pueda acceder a los archivos del bucket sin autorización.
#acls = Access Control List, que es una lista de control de acceso que define quién puede acceder a un recurso y qué acciones pueden realizar sobre él.

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}