# Azure API Management Policies

Reusable policy XML and templates for Azure API Management (APIM).

## Global rate-limit policy

File: `global-policy.xml`

- Limits requests to 100 calls per 60-second window.
- Uses the subscription ID when available; otherwise uses the request IP.
- Terraform attaches this policy at APIM service scope.
- API-level policies must retain `<base />` in their inbound section to inherit it.

This rate limit is not a substitute for authentication, authorization, or
partner-specific access controls.

## Microsoft Entra ID JWT validation

Template: `jwt-validation-policy.xml.tftpl`

Terraform renders this template using these dev environment variables:

- `entra_tenant_id`: Microsoft Entra tenant UUID.
- `api_audience`: expected token audience.
- `allowed_client_application_ids`: approved client application UUIDs.

JWT validation is optional by default. External and partner product flags
require JWT validation to be enabled and configured before the configuration
guard permits the configuration.

Do not enable external or partner products until API-level and backend
authorization boundaries have been reviewed. A shared API JWT allowlist does
not, by itself, distinguish partner access from public consumer access.

## Local validation

Run from the repository root:

```bash
terraform -chdir=terraform/environments/dev fmt -check
terraform -chdir=terraform/environments/dev validate
git diff --check
```

Terraform validation requires initialization first if the working directory
has not been initialized. Use `terraform init -backend=false` for local
validation without configuring a remote backend.

XML well-formedness alone does not guarantee APIM runtime compatibility.
No Azure deployment is performed by these checks.
