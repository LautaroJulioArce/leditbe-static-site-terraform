# Landing Page en AWS con Terraform

Proyecto de infraestructura como código realizado con Terraform y AWS para desplegar la landing page de LED IT BE.

## Arquitectura

```text
Usuario
   ↓ HTTPS
CloudFront
   ↓ OAC
Bucket S3 privado
```

## Tecnologías utilizadas

- Terraform
- Amazon S3
- Amazon CloudFront
- Origin Access Control (OAC)
- AWS CLI
- Git y GitHub
- GitHub Actions

## Características

- Bucket S3 privado.
- Acceso público bloqueado.
- CloudFront conectado a S3 mediante OAC.
- Política del bucket limitada a CloudFront.
- Redirección de HTTP a HTTPS.
- Caché optimizada para contenido estático.
- Infraestructura organizada en distintos archivos `.tf`.
- Configuración parametrizada mediante `variables.tf` y `terraform.tfvars`.
- Validación automática de Terraform mediante GitHub Actions.

## Sitio desplegado

https://dpinkajnni387.cloudfront.net

## Migración del contenido

La landing page estaba almacenada originalmente en un bucket creado manualmente en `us-east-2`.

El contenido fue sincronizado hacia el bucket administrado con Terraform en `us-east-1`:

```powershell
aws s3 sync s3://cuadros-led-2026 s3://landing-page-cuadros-led-lautaro `
  --source-region us-east-2 `
  --region us-east-1
```

Después de verificar los archivos, se realizó una invalidación de la caché de CloudFront:

```powershell
aws cloudfront create-invalidation `
  --distribution-id E1BDZM9BEE3CKV `
  --paths "/*"
```

Finalmente, se comprobó que CloudFront utilizara el bucket nuevo como origen y se eliminó el bucket anterior.

## Actualizar los archivos del sitio

```powershell
aws s3 sync .\site s3://landing-page-cuadros-led-lautaro
```

Después de actualizar archivos existentes, puede ser necesario invalidar la caché de CloudFront:

```powershell
aws cloudfront create-invalidation `
  --distribution-id E1BDZM9BEE3CKV `
  --paths "/*"
```

## Variables

Los valores configurables se definen en `terraform.tfvars`:

- Región de AWS.
- Nombre del bucket S3.
- Tags comunes del proyecto.

## Comandos principales

```powershell
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Para consultar la URL de CloudFront:

```powershell
terraform output -raw cloudfront_url
```
## Integración continua

El repositorio incluye un workflow de GitHub Actions que se ejecuta con cada `push` o pull request hacia la rama `main`.

El pipeline realiza las siguientes validaciones:

- `terraform fmt -check`
- `terraform init -backend=false`
- `terraform validate`

El despliegue de la infraestructura mediante `terraform apply` se mantiene manual.

## Próximos pasos

- Configurar un dominio personalizado.

## 🎨 Aplicación frontend

La landing page desplegada con esta infraestructura se encuentra en un repositorio separado:

[Ver repositorio del frontend](https://github.com/LautaroJulioArce/leditbe-cuadros-web)

[Ver sitio en producción](https://dpinkajnni387.cloudfront.net)
