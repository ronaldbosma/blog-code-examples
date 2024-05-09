//=============================================================================
// Key Vault Permissions
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('The name of the Key Vault that will contain the secrets')
@maxLength(24)
param keyVaultName string

@description('The ID of the user that will be granted Key Vault Administrator rights to the Key Vault.')
param keyVaultAdministratorId string

@description('The name of the API Management Service that will be granted permissions')
param apiManagementServiceName string

//=============================================================================
// Existing Resources
//=============================================================================

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementServiceName
}

//=============================================================================
// Resources
//=============================================================================

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


// Grant the API Management Service access to the Key Vault

var keyVaultSecretsUserRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')

resource grantApimKeyVaultAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('grant-${apiManagementServiceName}-${keyVaultName}-${keyVaultSecretsUserRole}')
  scope: keyVault
  properties: {
    roleDefinitionId: keyVaultSecretsUserRole
    principalId: apiManagementService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
