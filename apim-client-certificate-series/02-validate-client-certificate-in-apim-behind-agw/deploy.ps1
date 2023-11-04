param (
    [string]$ResourceGroupName = 'rg-validate-client-certificate',
    [string]$Location = 'westeurope',
    [string]$ApiManagementServiceName = 'apim-validate-client-certificate'
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
$publisherEmail = $signedInUser.mail
$publisherName = $signedInUser.displayName

# Deploy the resources with Bicep
az deployment group create `
    --name "deploy-validate-client-certificate-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './main.bicep' `
    --parameters apiManagementServiceName=$ApiManagementServiceName `
                 publisherEmail=$publisherEmail `
                 publisherName=$publisherName `
    --verbose