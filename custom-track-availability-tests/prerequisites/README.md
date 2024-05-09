# Prerequisites

This is a diagram of the resources that will be deployed as part of the prerequisites:

![Prerequisites](./prerequisites.drawio.png)

The [main.bicep](./main.bicep) defines the following resources:
- Key Vault with RBAC authorization enabled (the firewall is not enabled).
- Azure API Management Consumption tier instance with a system-assigned identity.
- Role assignment to assign the specified user the 'Key Vault Administrator' role.

The [deploy.ps1](./deploy.ps1) script deploys the resources using the Azure CLI. It will:
- Create a new resource group if it does not exist.
- If `KeyVaultAdministratorId`, `PublisherName` or `PublisherEmail` is not provided, the script will get this data from the signed in user.
- Validate the deployment of [main.bicep](./main.bicep) to the resource group.
- Deploy [main.bicep](./main.bicep) to the resource group.

You can deploy the prerequisites using the following snippet:

```powershell
$resourceGroupName = '<your-resource-group-name>'
$functionAppName = '<your-function-app-name>'
$logAnalyticsWorkspaceName = '<your-log-analytics-workspace-name>'
$appInsightsName = '<your-application-insights-name>'
$keyVaultName = '<your-key-vault-name>'
$apiManagementServiceName = '<your-api-management-service-name>'

./deploy.ps1 -ResourceGroupName $resourceGroupName `
             -LogAnalyticsWorkspaceName $logAnalyticsWorkspaceName `
             -AppInsightsName $appInsightsName `
             -KeyVaultName $keyVaultName `
             -ApiManagementServiceName $apiManagementServiceName
```

This example will deploy the Key Vault with `Allow public access from all networks` enabled.

You can find the parameters for `deploy.ps1` PowerShell script and corresponding Bicep parameters of the `main.bicep` in the table below:

| PS Parameter | Bicep Parameter | Description |
|-|-|-|
| N/A | tenantId | The Azure AD tenant ID. Default: tenant id of the resource group. |
| Location | location | The location for the resources. Default: `norwayeast` |
| ResourceGroupName | N/A | The name of the resource group to which the resources in the `main.bicep` are deployed to. Will be created if it doesn't exist |
| FunctionAppName | functionAppName | The name of the Azure Function App to be created. |
| StorageAccountName | storageAccountName | The name of the Storage Account that will be used by the Function App. |
| LogAnalyticsWorkspaceName | logAnalyticsWorkspaceName | The name of the Log Analytics workspace to be created. |
| AppInsightsName | appInsightsName | The name of the Application Insights instance to be created. |
| N/A | retentionInDays | The retention period for the Log Analytics workspace and Application Insights. Default: `30` |
| KeyVaultName | keyVaultName | The name of the Key Vault to be created. |
| KeyVaultAdministratorId | keyVaultAdministratorId | The object ID of the user to be assigned the 'Key Vault Administrator' role. If `$null` then the id of the logged in uer is used. If an empty string is specified, the role is not assigned. |
| KeyVaultNetworkAclsDefaultAction | keyVaultNetworkAclsDefaultAction | Defaults to `Allow`. Set to `Deny` to enable `Allow public access from specific virtual networks and IP addresses` and optionally add an allowed ip addres to `KeyVaultAllowedIpAddress` |
| KeyVaultAllowedIpAddress | keyVaultAllowedIpAddress | The allowed IP address for the Key Vault. Default: empty |
| ApiManagementServiceName | apiManagementServiceName | The name of the API Management service to be created. |
| ApiManagementPublisherName | apiManagementPublisherName | The name of the publisher of the API Management service. If not specified, the display name of the logged in user is used. |
| ApiManagementPublisherEmail | apiManagementPublisherEmail | The email of the publisher of the API Management service. If not specified, the email of the logged in user is used. |


## Enable Key Vault Firewall

If you want to enable `Allow public access from specific virtual networks and IP addresses`, set the parameter `KeyVaultNetworkAclsDefaultAction` to `Deny` and optionally pass your ip address in `KeyVaultAllowedIpAddress` so you can access the Key Vault.

Here's an example:

```powershell
$resourceGroupName = '<your-resource-group-name>'
$functionAppName = '<your-function-app-name>'
$logAnalyticsWorkspaceName = '<your-log-analytics-workspace-name>'
$appInsightsName = '<your-application-insights-name>'
$keyVaultName = '<your-key-vault-name>'
$apiManagementServiceName = '<your-api-management-service-name>'
$yourIpAddress = '<your-ip-address>'

./deploy.ps1 -ResourceGroupName $resourceGroupName `
             -KeyVaultName $keyVaultName `
             -ApiManagementServiceName $apiManagementServiceName `
             -KeyVaultNetworkAclsDefaultAction "Deny" `
             -KeyVaultAllowedIpAddress $yourIpAddress
```