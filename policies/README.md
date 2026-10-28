# Azure API Management Policies

This directory contains reusable Azure API Management (APIM) policy templates.

## Policies

### 1. global-policy.xml

- Applies a rate limit of 100 calls per 60-second window.
- Uses the subscription ID as the rate-limit key when available.
- Falls back to the request IP address when no subscription is available.
- Preserves inherited policies through the `<base />` element.

### 2. jwt-validation-policy.xml

- Template for validating Microsoft Entra ID access tokens.
- Includes placeholders for the tenant ID, API audience, and allowed client application ID.
- Must be configured for the target identity and API before use.

## Configuration requirements

Replace these placeholders in `jwt-validation-policy.xml`:

- `REPLACE_WITH_TENANT_ID`
- `REPLACE_WITH_API_APPLICATION_ID_URI`
- `REPLACE_WITH_ALLOWED_CLIENT_APPLICATION_ID`

Use values from the intended Microsoft Entra ID tenant and app registrations.

## Validation

Run XML well-formedness checks locally:

```bash
python3 -c 'import xml.etree.ElementTree as ET; from pathlib import Path; files=sorted(Path("policies").glob("*.xml")); assert files, "No policy XML files found"; [ET.parse(p) for p in files]; [print("VALID XML:", p) for p in files]'
```

XML well-formedness does not guarantee that a policy is valid in the APIM runtime.
