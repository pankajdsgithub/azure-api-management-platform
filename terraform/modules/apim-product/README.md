# APIM product Terraform module

Creates a product in an existing Azure API Management service and
optionally associates one or more existing APIs with it.

## Inputs

- `resource_group_name`
- `api_management_name`
- `product_id`
- `display_name`
- `description`
- `approval_required` (default: `true`)
- `subscription_required` (default: `true`)
- `published` (default: `false`)
- `subscriptions_limit` (optional positive integer)
- `terms` (optional)
- `api_names` (set of existing API identifiers; defaults to empty)

## Outputs

- `id`
- `product_id`
- `associated_api_names`

## Security and lifecycle notes

- Subscription keys are not a substitute for JWT authentication.
- Product association does not itself configure API-level authorization.
- Products are unpublished by default; review intended consumers before publishing.
- API identifiers supplied in `api_names` must refer to APIs in the same APIM service.
- This module does not create the APIM service or the APIs.

## Deployment status

Local implementation only. No Azure resources have been deployed.
