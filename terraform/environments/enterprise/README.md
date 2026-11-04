# Enterprise external API environment

## Purpose
This environment models an enterprise APIM deployment for approved external API consumers while keeping the same local-only guardrails as the rest of the repository.

## Current status
- APIM service, APIs, products, and JWT policy modules are wired into the enterprise root configuration.
- The external-facing consumer product is enabled by default.
- Partner publishing remains opt-in and requires the same JWT validation review as the dev configuration.
- The existing Azure Resource Group is referenced, not created.

## Safety
- Replace all REPLACE_ placeholder values with approved values before planning or applying.
- The terraform_data.configuration_guard precondition enforces valid Entra settings whenever external or partner product access is enabled.
- No Azure resources are deployed during local validation.

## Local validation
Run from the repository root:

    terraform -chdir=terraform/environments/enterprise init -backend=false
    terraform -chdir=terraform/environments/enterprise validate
    terraform fmt -check -recursive terraform/environments/enterprise

## Deployment status
No Azure deployment is performed during local validation.
