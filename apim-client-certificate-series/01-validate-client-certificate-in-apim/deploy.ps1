param (
    [string]$ResourceGroupName = 'rg-validate-client-certificate',
    [string]$Location = 'westeurope',
    [string]$ApiManagementServiceName = 'apim-validate-client-certificate',
    [string]$PublisherName = $null,
    [string]$PublisherEmail = $null
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
if (($null -eq $PublisherName) -or ($null -eq $PublisherEmail))
{
    Write-Host "what"
    $signedInUser = az ad signed-in-user show | ConvertFrom-Json
    if ($null -eq $PublisherName)
    {
        $PublisherName = $signedInUser.displayName
    }
    if ($null -eq $PublisherEmail)
    {
        $PublisherEmail = $signedInUser.mail
    }
}


# Deploy the resources with Bicep
az deployment group create `
    --name "deploy-validate-client-certificate-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './main.bicep' `
    --parameters apiManagementServiceName=$ApiManagementServiceName `
                 publisherName=$PublisherName `
                 publisherEmail=$PublisherEmail `
    --verbose