# APIM API Terraform module

Imports an OpenAPI JSON document into an existing Azure API Management service.

## Inputs

- `name`: stable API identifier.
- `display_name`: friendly API name.
- `resource_group_name`: existing APIM resource group.
- `api_management_name`: existing APIM service name.
- `path`: relative API gateway path, without a leading slash.
- `openapi_spec_content`: OpenAPI JSON text supplied by the caller.
- `service_url`: optional backend base URL.
- `protocols`: gateway protocols; defaults to HTTPS.
- `revision`: API revision; defaults to `1`.
- `subscription_required`: subscription-key requirement; defaults to `true`.

## Outputs

- `id`
- `name`
- `path`

## Security notes

Subscription keys are not a replacement for Microsoft Entra ID JWT validation.
Configure and test APIM policies separately.

A successful Terraform validation does not verify Azure-side OpenAPI import,
backend reachability, or APIM policy runtime behavior.

## Deployment status

Local implementation only. No Azure resources have been deployed.
