# Landing Page en AWS con Terraform

Primer proyecto de infraestructura como código realizado con Terraform y AWS.

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

## Características

- Bucket S3 privado.
- Acceso público bloqueado.
- CloudFront conectado a S3 mediante OAC.
- Política del bucket limitada a CloudFront.
- Redirección de HTTP a HTTPS.
- Caché optimizada para contenido estático.

## Sitio desplegado

https://dpinkajnni387.cloudfront.net

## Actualizar los archivos del sitio

```powershell
aws s3 sync .\site s3://landing-page-cuadros-led-lautaro
```

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

## Próximos pasos

- Reemplazar la página de prueba por la landing completa. La cual incluirá html, css y js. 
- Dominio web.
- Separar la configuración en varios archivos `.tf`.
- Incorporar variables.
- Automatizar validaciones y despliegues con GitHub Actions.

## 🎨 Aplicación frontend

La landing page desplegada con esta infraestructura se encuentra en un repositorio separado:

[Ver repositorio del frontend](https://github.com/LautaroJulioArce/leditbe-cuadros-web)

[Ver sitio en producción](https://dpinkajnni387.cloudfront.net)
