# AWS CloudFront Distribution con S3, Origen & WAFv2

Este módulo de Terraform despliega una distribución de AWS CloudFront altamente configurable, con soporte para múltiples orígenes (S3 y API Gateway), gestión de caché avanzada, y una integración robusta con AWS WAFv2 para la seguridad. También configura los buckets S3 asociados para el alojamiento de contenido estático y el registro de CloudFront, aplicando las mejores prácticas de seguridad.

## Estructura del Proyecto

El código está organizado en los siguientes módulos y archivos principales:

-   `main.tf`: Archivo principal que orquesta la creación de los recursos utilizando módulos.
-   `variables.tf`: Define todas las variables de entrada para el módulo raíz.
-   `outputs.tf`: Define las salidas del módulo raíz.
-   `terraform.tfvars`: Archivo de ejemplo para la definición de variables locales y de entrada.
-   `providers.tf`: Configuración de los proveedores de Terraform (AWS).
-   `state.tf`: Configuración del backend S3 para el estado de Terraform.
-   `locals.tf`: Definiciones de variables locales para simplificar la configuración.

### Módulos Internos

-   `./cloudfront`: Configura la distribución de CloudFront.
-   `./cloudfront_oai`: Crea un Origin Access Identity (OAI) para S3.
-   `./s3`: Gestiona los buckets S3 para el contenido y los logs.
-   `./s3_website`: Configura un bucket S3 como sitio web estático.
-   `./waf`: Despliega y configura AWS WAFv2.

## Componentes Principales

### CloudFront (`./cloudfront`)

Este módulo crea una distribución de CloudFront con las siguientes características:

* **Múltiples Orígenes**:
    * [cite_start]Un origen S3 configurado con un Origin Access Identity (OAI) para restringir el acceso directo al bucket.
    * [cite_start]Un origen de API Gateway, permitiendo servir APIs a través de CloudFront.
* **Comportamiento de Caché por Defecto**:
    * [cite_start]Permite métodos `GET` y `HEAD`.
    * [cite_start]Redirige automáticamente el tráfico HTTP a HTTPS (`redirect-to-https`).
    * [cite_start]Configuración de TTLs (`min_ttl`, `default_ttl`, `max_ttl`).
    * [cite_start]No reenvía `query_string` ni `cookies` por defecto para el caché.
* [cite_start]**Comportamientos de Caché Ordenados (`ordered_cache_behavior`)**: Permite definir comportamientos de caché personalizados basados en patrones de ruta (`path_pattern`), métodos HTTP permitidos, métodos cacheados, origen de destino, compresión y políticas de protocolo de visualización. Esto es ideal para optimizar el caché de diferentes tipos de contenido.
* [cite_start]**Respuestas de Error Personalizadas**: Configura el manejo de errores para códigos HTTP específicos, redirigiendo a una página de error personalizada con un TTL de caché definido.
* [cite_start]**Logging**: Habilita el registro de acceso de CloudFront en un bucket S3 dedicado para análisis de logs.
* [cite_start]**Integración WAF**: Se asocia con un Web ACL de AWS WAFv2 para la protección de la distribución.
* [cite_start]**Soporte IPv6**: Habilitado por defecto.
* [cite_start]**Default Root Object**: `index.html` está configurado como el objeto raíz por defecto.
* [cite_start]**Price Class**: Configurado para `PriceClass_All`.
* [cite_start]**Restricciones Geográficas**: No se aplican restricciones geográficas por defecto (`restriction_type = "none"`).
* [cite_start]**Certificado del Visor**: Utiliza el certificado por defecto de CloudFront.

### CloudFront OAI (`./cloudfront_oai`)

[cite_start]Este módulo crea un AWS CloudFront Origin Access Identity (OAI), que es esencial para permitir que CloudFront acceda de forma segura a un bucket S3 mientras se restringe el acceso público directo al mismo.

### S3 (`./s3`)

Este módulo gestiona la creación de buckets S3, diseñados para almacenar contenido estático y logs. Incluye las siguientes configuraciones de seguridad y gestión:

* [cite_start]**Acceso Restringido**: Los buckets S3 son privados (`acl = "private"`).
* [cite_start]**Bloqueo de Acceso Público**: Bloquea todas las ACLs y políticas públicas para asegurar que los buckets no sean accesibles directamente desde la web.
* [cite_start]**Control de Versiones**: Habilita el control de versiones en los buckets para proteger contra eliminaciones accidentales y facilitar la recuperación de datos.
* [cite_start]**Cifrado del Lado del Servidor**: Configura el cifrado por defecto usando `AES256` para todos los objetos cargados en el bucket.
* [cite_start]**Política de Bucket**: Adjunta una política de bucket que permite a la OAI de CloudFront obtener objetos y listar el bucket, asegurando que solo CloudFront pueda servir el contenido.

### S3 Website (`./s3_website`)

[cite_start]Este módulo configura un bucket S3 existente para funcionar como un sitio web estático, especificando el documento de índice por defecto (generalmente `index.html`).

### WAF (`./waf`)

Este módulo despliega y configura AWS WAFv2, proporcionando una capa de seguridad para la distribución de CloudFront. Incluye la creación de:

* **Conjuntos de IP (`aws_wafv2_ip_set`)**:
    * **Listas Blancas (Whitelist)**: Conjuntos de IPs IPv4 e IPv6 permitidas, que tienen la máxima prioridad y evitan el bloqueo de tráfico legítimo.
    * [cite_start]**Listas Negras (Blacklist)**: Conjuntos de IPs IPv4 e IPv6 bloqueadas, para detener el tráfico malicioso conocido.
    * [cite_start]**Escáneres y Sondas (ScannersProbes)**: IPs asociadas con actividades de escaneo y sondeo.
    * **Reputación (Block_Reputation)**: IPs con mala reputación conocida.
    * **Bad Bot Rule**: IPs identificadas como bots maliciosos.
* **Web ACL (`aws_wafv2_web_acl`)**:
    * **Reglas de Seguridad**:
        * **Whitelist Rule**: Permite explícitamente el tráfico de IPs en la lista blanca.
        * [cite_start]**Blacklist Rule**: Bloquea explícitamente el tráfico de IPs en la lista negra.
        * [cite_start]**Http Flood Rate Based Rule**: Limita la tasa de solicitudes por IP para mitigar ataques de denegación de servicio (DoS).
        * **Scanners and Probes Rule**: Bloquea IPs que realizan escaneos y sondas.
        * [cite_start]**IP Reputation Lists Rule**: Bloquea IPs de listas de reputación conocidas.
        * [cite_start]**Bad Bot Rule**: Bloquea bots maliciosos.
        * **SQL Injection Rule**: Reglas para detectar y bloquear ataques de inyección SQL en `query_string`, `body`, `uri_path`, y encabezados como `authorization` y `cookie`.
        * [cite_start]**XSS Rule**: Reglas para detectar y bloquear ataques de Cross-Site Scripting (XSS) en `query_string`, `body`, `uri_path`, y encabezados como `cookie`.
    * [cite_start]**Métricas y Logging**: Todas las reglas y el Web ACL tienen métricas de CloudWatch habilitadas para monitoreo.
    * **Ámbito (Scope)**: Puede ser `REGIONAL` o `CLOUDFRONT`.

## Variables de Entrada

Las variables están definidas en `variables.tf` y sus valores por defecto o ejemplos se encuentran en `terraform.tfvars`.

### Global Variables

* `aws_region` (string): Región de AWS donde se desplegarán los recursos.
* `stack_id` (string): Identificador único para el stack, utilizado para nombrar recursos.

### CloudFront Variables

* `s3_name` (list(string)): Lista de nombres para los buckets S3.
* `apgw_id` (string): ID de la API Gateway a usar como origen.
* `api_gw_origin_id` (string): ID de origen para la API Gateway en CloudFront.
* `s3domain` (list(string)): Dominios de los buckets S3 para los orígenes.
* `origin_access_identitypath` (string): Ruta del Origin Access Identity de CloudFront.
* `cloudfront_error_caching_min_ttl` (number): TTL mínimo para las respuestas de error cacheadas.
* `cloudfront_response_code` (number): Código de respuesta HTTP para errores personalizados.
* `cloudfront_response_page_path` (string): Ruta a la página de error personalizada.
* `cloudfront_error_code` (number): Código de error HTTP a manejar.
* `cloudfront_origin_id` (string): ID del origen S3.
* `origin_path` (string): Ruta de origen para API Gateway.
* `ordered_cache_behavior` (list(object)): Lista de configuraciones para comportamientos de caché ordenados, incluyendo `path_pattern`, `allowed_methods`, `cached_methods`, `target_origin_id`, `viewer_protocol_policy`, `min_ttl`, `compress`, `default_ttl`, `max_ttl`.
* `cloudfront_s3_origin_id` (string): ID del origen S3 para el comportamiento de caché por defecto.

### WAF Global Variables

* `waf_global_id` (string): ARN de la Web ACL de WAF global si existe.

### S3 Variables

* `cloudfront_oai_arn` (string): ARN del Origin Access Identity de CloudFront.

### S3_website Variables

* `s3_bucket_website` (string): Nombre del bucket S3 configurado como sitio web estático.
* `s3_bucket_website_index_suffix` (string): Documento de índice para el sitio web S3.

### WAF Variables

* `wafv2_description` (string): Descripción de la Web ACL de WAFv2.
* `wafv2_scope` (list(string)): Alcance de la Web ACL (`REGIONAL` o `CLOUDFRONT`).
* `wafv2_ipset_whitelist_ipv4` (list(string)): Lista de IPs IPv4 para la lista blanca.
* `wafv2_ipset_whitelist_ipv6` (list(string)): Lista de IPs IPv6 para la lista blanca.
* `wafv2_ipset_blacklist_ipv4` (list(string)): Lista de IPs IPv4 para la lista negra.
* `wafv2_ipset_blacklist_ipv6` (list(string)): Lista de IPs IPv6 para la lista negra.
* `wafv2_ipset_ScannersProbes_ipv4` (list(string)): Lista de IPs IPv4 para escáneres y sondas.
* `wafv2_ipset_ScannersProbes_ipv6` (list(string)): Lista de IPs IPv6 para escáneres y sondas.
* `wafv2_ipset_Block_Reputation_ipv4` (list(string)): Lista de IPs IPv4 con mala reputación.
* `wafv2_ipset_Block_Reputation_ipv6` (list(string)): Lista de IPs IPv6 con mala reputación.
* `wafv2_ipset_BadBotRule_ipv4` (list(string)): Lista de IPs IPv4 para bots maliciosos.
* `wafv2_ipset_BadBotRule_ipv6` (list(string)): Lista de IPs IPv6 para bots maliciosos.

### Environment Taxonomy (Variables Locales de `terraform.tfvars`)

* `local_tag_cloud` (string)
* `local_tag_reg` (string)
* `local_tag_ou` (string)
* `local_tag_pro` (string)
* `local_tag_env` (string)

Estas variables se utilizan para construir el `stack_id` localmente y para aplicar etiquetas por defecto a los recursos de AWS.

## Salidas

Las salidas proporcionan información útil sobre los recursos desplegados:

* **CloudFront**:
    * `cloudfront_arn`: ARN de la distribución de CloudFront.
* **CloudFront OAI**:
    * `oai_arn`: ARN de la Origin Access Identity de CloudFront.
    * [cite_start]`oai_path`: Ruta de la Origin Access Identity de CloudFront.
* **S3**:
    * [cite_start]`s3bucketname`: Nombres de los buckets S3.
    * [cite_start]`s3bucketdomain`: Nombres de dominio regional de los buckets S3.
    * `s3bucketarn`: ARNs de los buckets S3.
* **S3 Website**:
    * `s3_website_endpoint`: Endpoint del sitio web S3.
* **WAF**:
    * `waf_global_arn`: ARN de la Web ACL de WAF global (si el scope es `CLOUDFRONT`).

## Uso

1.  **Configuración de Backend**: Asegúrate de que el backend S3 para el estado de Terraform esté configurado correctamente en `state.tf`.
2.  **Variables**: Completa el archivo `terraform.tfvars` con los valores apropiados para tu entorno. Presta especial atención a las IPs en las listas de WAF para evitar bloqueos no deseados.
3.  **Inicialización**: Ejecuta `terraform init` para inicializar el directorio de trabajo de Terraform y descargar los proveedores y módulos necesarios.
4.  **Planificación**: Ejecuta `terraform plan` para ver un resumen de los cambios que Terraform realizará.
5.  **Aplicación**: Ejecuta `terraform apply` para desplegar la infraestructura en tu cuenta de AWS.

## Consideraciones Adicionales

* **Etiquetado**: El módulo utiliza un esquema de etiquetado basado en variables locales (`local_tag_cloud`, `local_tag_reg`, etc.) para aplicar etiquetas consistentes a los recursos. Asegúrate de configurar estas variables según la taxonomía de tu organización.
* **Seguridad**: El módulo incluye una configuración de WAFv2 robusta con varias reglas de seguridad. Revisa y ajusta las listas de IPs y las reglas de WAF según tus necesidades específicas.
* **Optimización de Caché**: Los `ordered_cache_behavior` permiten una gran flexibilidad. Planifica cuidadosamente tus patrones de ruta y políticas de caché para optimizar el rendimiento y reducir los costos de CloudFront.
* **Control de Versiones en S3**: La habilitación del control de versiones en S3 es una buena práctica, pero ten en cuenta que puede aumentar el almacenamiento y los costos asociados.
* **Observabilidad**: Se recomienda monitorear las métricas de CloudWatch generadas por CloudFront y WAF para observar el tráfico y la efectividad de las reglas de seguridad.
