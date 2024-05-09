//=============================================================================
// Creates User-Assigned Managed Identities and grants role assignments
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('Location to use for all resources')
param location string

@description('The name of the Key Vault that will contain the secrets')
@maxLength(24)
param keyVaultName string

@description('The ID of the user that will be granted Key Vault Administrator rights to the Key Vault.')
param keyVaultAdministratorId string

@description('The name of the API Management Service that will be granted permissions')
param apiManagementServiceName string

//=============================================================================
// Variables
//=============================================================================

var keyVaultSecretsUserRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
var keyVaultAdministratorRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483')

//=============================================================================
// Existing Resources
//=============================================================================

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

//=============================================================================
// Resources
//=============================================================================

// Create a user-assigned managed identity for the API Management Service

resource apimIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-${apiManagementServiceName}'
  location: location
}

// Grant the API Management Service access to the Key Vault

resource grantApimKeyVaultAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('grant-${apiManagementServiceName}-${keyVaultName}-${keyVaultSecretsUserRole}')
  scope: keyVault
  properties: {
    roleDefinitionId: keyVaultSecretsUserRole
    principalId: apimIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}


// Grant the specified administrator access to the Key Vault

resource grantAdministratorKeyVaultAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('grant-${keyVaultAdministratorId}-${keyVaultName}-${keyVaultAdministratorRole}')
  scope: keyVault
  properties: {
    roleDefinitionId: keyVaultAdministratorRole
    principalId: keyVaultAdministratorId
    principalType: 'User'
  }
}


//=============================================================================
// Outputs
//=============================================================================

output apimIdentityName string = apimIdentity.name
