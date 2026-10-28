# Dev Environment

## Current Status
- Terraform modules are wired into the dev root configuration.
- The existing Azure Resource Group is referenced, not created.
- APIM, APIs, product, policies, and optional diagnostics are configured through modules.
- The internal product is unpublished by default.
- JWT policies are disabled by default.

## Safety
- Replace all REPLACE_ placeholder values with approved values before planning or applying.
- The terraform_data.configuration_guard precondition checks placeholder configuration.
- All seven APIM configuration modules depend on the guard.
- Verify approved regions, tags, networking, backend reachability, identity, and authorization before deployment.
- terraform validate does not prove deployment readiness or verify Azure permissions and resource availability.

## Local Validation
Run from the repository root:

    terraform -chdir=terraform/environments/dev init -backend=false
    terraform -chdir=terraform/environments/dev validate
    terraform fmt -check -recursive terraform/environments/dev

These checks do not deploy Azure resources.

## Deployment Status
No Azure deployment is performed during local validation.
