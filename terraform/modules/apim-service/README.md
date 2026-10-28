# APIM Service Terraform Module

## Purpose

Creates an Azure API Management service using the Standard v2 SKU.

This module manages the APIM service only. It does not create the
resource group, virtual network, private endpoint, DNS zones, backend
services, API definitions, products, or API policies.

## Supported configuration

- Terraform: >= 1.6.0
- AzureRM provider: >= 4.40.0, < 5.0.0
- APIM SKU: `StandardV2_1`
- Identity: system-assigned managed identity
- Tags: supplied by the calling configuration

## Inputs

| Name | Required | Description |
|---|---|---|
| `name` | Yes | APIM service name |
| `location` | Yes | Azure region |
| `resource_group_name` | Yes | Name of an existing resource group |
| `publisher_name` | Yes | APIM publisher organization |
| `publisher_email` | Yes | Publisher contact email |
| `sku_name` | No | Defaults to `StandardV2_1`; other values are rejected |
| `tags` | No | Organizational tags; defaults to an empty map |

## Outputs

- `id`: APIM resource ID
- `name`: APIM service name
- `gateway_url`: Default gateway URL
- `developer_portal_url`: Default developer portal URL
- `identity_principal_id`: System-assigned identity principal ID

The default gateway URL does not guarantee private-only access.

## Hybrid architecture considerations

The platform is intended to support internal/private APIs and external
partner APIs. This module alone does not implement that separation.

Before deployment, design and validate:

- Inbound private access and Private Endpoint DNS.
- Public gateway exposure and the decision to disable public access.
- Outbound VNet integration for private backend connectivity.
- JWT validation, API authorization, and partner access controls.
- TLS certificates, custom domains, diagnostics, and monitoring.
- Network isolation requirements for internal versus partner APIs.

A Private Endpoint does not, by itself, ensure that selected APIs are
private while other APIs remain public. Validate the intended ingress
architecture against the selected APIM tier and current Azure
capabilities.

## Validation

Run the following commands from the repository root:

```bash
terraform -chdir=terraform/modules/apim-service fmt -check
terraform -chdir=terraform/modules/apim-service validate
```

These commands validate local configuration; they do not deploy Azure
resources.

## Deployment status

This module is implemented and locally validated. Azure deployment has
not been performed as part of this local-only workflow.
