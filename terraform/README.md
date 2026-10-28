# Terraform Platform Foundation

## Purpose
Build a reusable, secure Azure API Management platform.

## Module boundaries
- apim-service: APIM service configuration and identity.
- apim-api: API import, versioning and backend configuration.
- apim-product: Products, API associations and subscriptions.
- apim-policy: Shared and API-specific policies.
- monitoring: Diagnostics, metrics and alert integration.

## Environment isolation
- dev: development validation.
- test: pre-production integration testing.
- prod: controlled production configuration.

Each environment must have independent state and explicit configuration.
Production changes require review and approval.

## Security requirements
- Do not commit credentials, secrets, tokens or real environment tfvars.
- Prefer managed identity and Key Vault where supported.
- Apply least-privilege RBAC.
- Validate OpenAPI contracts and APIM policy compatibility.
- Run Terraform fmt, validate and security checks in CI.
- Review plans before any apply.

## Deployment guardrail
This foundation does not authorize or perform Azure deployment.
Backend state, APIM tier, networking and identity must be decided before
deployable environment configurations are completed.
