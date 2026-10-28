# APIM Monitoring Module

Creates an Azure Monitor diagnostic setting for an existing Azure resource,
typically an Azure API Management service, and routes selected logs and/or
metrics to an existing Log Analytics workspace.

## Inputs

| Name | Required | Description |
|---|---|---|
| `name` | Yes | Diagnostic setting name |
| `target_resource_id` | Yes | Existing APIM resource ID |
| `log_analytics_workspace_id` | Yes | Existing Log Analytics workspace resource ID |
| `log_categories` | No | Set of supported log categories; defaults to empty |
| `metric_categories` | No | Set of supported metric categories; defaults to empty |

At least one log or metric category must be selected.

## Outputs

- `diagnostic_setting_id`
- `target_resource_id`
- `log_analytics_workspace_id`

## Category discovery

Configure only categories supported by the target resource. Category support
can vary by resource type and SKU; this module does not discover categories.

## Security and scope

- Does not create an APIM service or Log Analytics workspace.
- Does not configure APIM gateway loggers or API-level diagnostics.
- Review sensitive-data handling before enabling request or response logging.
- No Azure deployment is performed by local validation.
