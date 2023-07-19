param (
    [string]$ResourceGroupName = 'rg-my-apim-client-cert-sample',
    [string]$Location = 'westeurope',
    [string]$KeyVaultName = 'kv-my-apim-client-certs',
    [string]$KeyVaultNetworkAclsDefaultAction = "Allow",
    [string]$KeyVaultAllowedIpAddress = "",
    [string]$ApiManagementServiceName = 'apim-my-client-certs-sample'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Create the resource group if it doesn't exist
if ((az group exists --name $ResourceGroupName) -eq "false")
{
    Write-Host "Create resource group: $ResourceGroupName"
    az group create --name $ResourceGroupName --location $Location
}

# Get the signed in user. This user will be the publisher of API Management.
$signedInUser = az ad signed-in-user show | ConvertFrom-Json
$keyVaultAdministratorId = $signedInUser.id
$publisherEmail = $signedInUser.mail
$publisherName = $signedInUser.displayName

# Deploy the resources with Bicep
az deployment group create `
    --name 'apim-client-cert-sample-prerequisites' `
    --resource-group $ResourceGroupName `
    --template-file './main.bicep' `
    --parameters keyVaultName=$KeyVaultName `
                 apiManagementServiceName=$ApiManagementServiceName `
                 keyVaultAdministratorId=$keyVaultAdministratorId `
                 keyVaultNetworkAclsDefaultAction=$KeyVaultNetworkAclsDefaultAction `
                 keyVaultAllowedIpAddress=$KeyVaultAllowedIpAddress `
                 publisherEmail=$publisherEmail `
                 publisherName=$publisherName `
    --verbose