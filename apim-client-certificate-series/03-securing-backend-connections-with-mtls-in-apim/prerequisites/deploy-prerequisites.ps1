param (
    [string]$ResourceGroupName = 'rg-secure-backend-with-mtls',
    [string]$Location = 'norwayeast',
    [string]$ApiManagementServiceClientName = 'apim-secure-backend-with-mtls-client',
    [string]$ApiManagementServiceBackendName = 'apim-secure-backend-with-mtls-backend',
    [string]$PublisherName = $null,
    [string]$PublisherEmail = $null,
    [string]$KeyVaultName = 'kvsecurebackendwithmtls',
    [string]$KeyVaultNetworkAclsDefaultAction = "Allow",
    [string]$KeyVaultAllowedIpAddress = "",
    [string]$KeyVaultAdministratorId = $null
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest


# Create the resource group if it doesn't exist
if ((az group exists --name $ResourceGroupName) -eq "false")
{
    Write-Host "Create resource group: $ResourceGroupName"
    az group create --name $ResourceGroupName --location $Location
}


# If the Publisher Name and/or Email was not specified, try to get the signed in user and use theirs.
# NOTE: depending on the access rights of the signed in user, this might fail.
if (-not($PublisherName) -or -not($PublisherEmail) -or -not($KeyVaultAdministratorId))
{
    $signedInUser = az ad signed-in-user show | ConvertFrom-Json
    if (-not($PublisherName))
    {
        $PublisherName = $signedInUser.displayName
    }
    if (-not($PublisherEmail))
    {
        $PublisherEmail = $signedInUser.mail
    }
    if (-not($KeyVaultAdministratorId))
    {
        $KeyVaultAdministratorId = $signedInUser.id
    }
}


# Print the time and date before starting the deployment so you can estimate when it's finished if you have an expected duration
Write-Host "Start deployment at: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")"

# Deploy the resources with Bicep
az deployment group create `
    --name "deploy-secure-backend-with-mtls-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './prerequisites.bicep' `
    --parameters apiManagementServiceClientName=$ApiManagementServiceClientName `
                 apiManagementServiceBackendName=$ApiManagementServiceBackendName `
                 publisherName=$PublisherName `
                 publisherEmail=$PublisherEmail `
                 keyVaultAdministratorId=$KeyVaultAdministratorId `
    --verbose