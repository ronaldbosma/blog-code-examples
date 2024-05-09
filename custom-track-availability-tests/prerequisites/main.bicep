//=============================================================================
// Prerequisites
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================


@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.')
param tenantId string = subscription().tenantId

@description('Location to use for all resources')
param location string = resourceGroup().location

@description('The name of the Key Vault that will contain the client certificate')
@maxLength(24)
param keyVaultName string

@description('The ID of the user that will be granted Key Vault Administrator rights to the Key Vault.')
param keyVaultAdministratorId string

@description('The default action on the Key Vault when no rule from ipRules and from virtualNetworkRules match.')
@allowed([ 'Allow', 'Deny' ])
param keyVaultNetworkAclsDefaultAction string = 'Allow'

@description('An IP address from which access to the Key Vault is allowed')
param keyVaultAllowedIpAddress string = ''

@description('The name of the API Management Service that will be created')
param apiManagementServiceName string

@description('The name of the owner of the API Management service')
param apiManagementPublisherName string

@description('The email address of the owner of the API Management service')
param apiManagementPublisherEmail string

//=============================================================================
// Resources
//=============================================================================


// Key Vault (see also: https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-bicep?tabs=CLI)

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: keyVaultNetworkAclsDefaultAction
      bypass: 'AzureServices'
      ipRules: empty(keyVaultAllowedIpAddress) ? [] : [ { value: keyVaultAllowedIpAddress } ]
    }
  }
}

// API Management - Consumption tier (see also: https://learn.microsoft.com/en-us/azure/api-management/quickstart-bicep?tabs=CLI)

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: apiManagementServiceName
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherName: apiManagementPublisherName
    publisherEmail: apiManagementPublisherEmail
  }
  identity: {
    type: 'SystemAssigned'
  }
}


// Grant the specified administrator access to the Key Vault

var keyVaultAdministratorRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483')

resource grantAdministratorKeyVaultAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('grant-${keyVaultAdministratorId}-${keyVaultName}-${keyVaultAdministratorRole}')
  scope: keyVault
  properties: {
    roleDefinitionId: keyVaultAdministratorRole
    principalId: keyVaultAdministratorId
    principalType: 'User'
  }
}
