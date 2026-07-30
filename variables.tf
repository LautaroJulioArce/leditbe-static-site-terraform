variable "aws_region" {
  description = "Región de AWS donde se crean los recursos"
  type        = string
}

variable "bucket_name" {
  description = "Nombre único del bucket S3"
  type        = string
}

variable "common_tags" {
  description = "Tags comunes para los recursos del proyecto"
  type        = map(string)
}