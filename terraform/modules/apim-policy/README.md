# APIM API policy module

Attaches a complete XML policy to an existing API in an existing
Azure API Management service.

## Inputs

- `resource_group_name`
- `api_management_name`
- `api_name`
- `xml_content`

## Output

- `api_name`

## Important

The XML checks in Terraform are basic structural checks, not APIM
runtime policy validation.

Use `<base />` in policy sections when inherited policies should run.
Review policy inheritance and ordering before deployment.

Do not commit real tenant identifiers, credentials, or other secrets.
Keep JWT validation configuration environment-specific.

This module has not been deployed to Azure.
