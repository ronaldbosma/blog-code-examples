param (
    [string]$ResourceGroupName = 'rg-secure-backend-with-mtls',
    [string]$Location = 'norwayeast',
    [string]$ApiManagementServiceClientName = 'apim-secure-backend-with-mtls-client',
    [string]$ApiManagementServiceBackendName = 'apim-secure-backend-with-mtls-backend',
    [string]$KeyVaultName = 'kvsecurebackendwithmtls'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest


# Print the time and date before starting the deployment so you can estimate when it's finished if you have an expected duration
Write-Host "Start deployment at: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")"

# Deploy the resources with Bicep
az deployment group create `
    --name "deploy-secure-backend-with-mtls-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './main.bicep' `
    --parameters apiManagementServiceClientName=$ApiManagementServiceClientName `
                 apiManagementServiceBackendName=$ApiManagementServiceBackendName `
                 keyVaultName=$KeyVaultName `
    --verbose