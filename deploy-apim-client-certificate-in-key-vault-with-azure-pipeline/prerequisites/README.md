# Prerequisites

The [main.bicep](./main.bicep) defines the following resources:
- Key Vault with RBAC authorization enabled (the firewall is not enabled).
- Azure API Management Consumption tier instance with a system-assigned identity.
- Role assignment to assign the 'Key Vault Secrets User' role to the API Management system-assigned identity.

The [deploy.ps1](./deploy.ps1) script deploys the resources. It will:
- Create a new resource group if it does not exist.
- Retrieve the email address and name of the signed in user. These are used for the publisher email and name of the API Management instance.
- Deploy [main.bicep](./main.bicep) to the resource group.

You can execute the scripts using the following snippet:

```powershell
$resourceGroupName = '<your-resource-group-name>'
$location = '<your-location>'
$keyVaultName = '<your-key-vault-name>'
$apiManagementServiceName = '<your-api-management-service-name>'

./deploy.ps1 -ResourceGroupName $resourceGroupName `
             -Location $location `
             -KeyVaultName $keyVaultName `
             -ApiManagementServiceName $apiManagementServiceName
```