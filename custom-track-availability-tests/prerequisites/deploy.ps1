param (
    [string]$Location = 'norwayeast',
    [string]$ResourceGroupName = 'rg-custom-track-availability-tests',
    [string]$LogAnalyticsWorkspaceName = "log-custom-track-availability-tests",
    [string]$AppInsightsName = "appi-custom-track-availability-tests",
    [string]$KeyVaultName = 'kv-custom-avail-tests',
    [string]$KeyVaultAdministratorId = $null,
    [string]$KeyVaultNetworkAclsDefaultAction = "Allow",
    [string]$KeyVaultAllowedIpAddress = "",
    [string]$ApiManagementServiceName = 'apim-custom-track-availability-tests',
    [string]$ApiManagementPublisherName = $null,
    [string]$ApiManagementPublisherEmail = $null
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest


# Create the resource group if it doesn't exist
if ((az group exists --name $ResourceGroupName) -eq "false")
{
    Write-Host "Create resource group: $ResourceGroupName"
    az group create --name $ResourceGroupName --location $Location
}


# If the Id of the Key Vault Administrators or Publisher Name and/or Email was not specified, try to get the signed in user and use theirs.
# NOTE: depending on the access rights of the signed in user, this might fail.
if (-not($KeyVaultAdministratorId) -or -not($ApiManagementPublisherName) -or -not($ApiManagementPublisherEmail))
{
    $signedInUser = az ad signed-in-user show | ConvertFrom-Json
    if (-not($KeyVaultAdministratorId))
    {
        $KeyVaultAdministratorId = $signedInUser.id
    }
    if (-not($ApiManagementPublisherName))
    {
        $ApiManagementPublisherName = $signedInUser.displayName
    }
    if (-not($ApiManagementPublisherEmail))
    {
        $ApiManagementPublisherEmail = $signedInUser.mail
    }
}


# Print the time and date before starting the deployment so you can estimate when it's finished if you have an expected duration
Write-Host "Start deployment at: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")"

# Deploy the resources with Bicep
az deployment group create `
    --name "deploy-custom-track-availability-tests-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './main.bicep' `
    --parameters logAnalyticsWorkspaceName=$LogAnalyticsWorkspaceName `
                 appInsightsName=$AppInsightsName `
                 keyVaultName=$KeyVaultName `
                 keyVaultAdministratorId=$KeyVaultAdministratorId `
                 keyVaultNetworkAclsDefaultAction=$KeyVaultNetworkAclsDefaultAction `
                 keyVaultAllowedIpAddress=$KeyVaultAllowedIpAddress `
                 apiManagementServiceName=$ApiManagementServiceName `
                 apiManagementPublisherName=$ApiManagementPublisherName `
                 apiManagementPublisherEmail=$ApiManagementPublisherEmail `
    --verbose
