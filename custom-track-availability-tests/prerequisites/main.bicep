//=============================================================================
// Prerequisites
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.')
param tenantId string = subscription().tenantId

@description('Location to use for all resources')
param location string = resourceGroup().location

@description('The name of the Function App that will be created')
param functionAppName string

@description('The name of the Log Analytics workspace that will be created')
param logAnalyticsWorkspaceName string

@description('The name of the App Insights instance that will be created and used by API other resources')
param appInsightsName string

@description('Retention in days of the logging')
param retentionInDays int = 30

@description('The name of the Key Vault that will contain the secrets')
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

module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVault'
  params: {
    tenantId: tenantId
    location: location
    keyVaultName: keyVaultName
    keyVaultNetworkAclsDefaultAction: keyVaultNetworkAclsDefaultAction
    keyVaultAllowedIpAddress: keyVaultAllowedIpAddress
  }
}

module identitiesAndRoleAssignments 'modules/identities-and-role-assignments.bicep' = {
  name: 'identitiesAndRoleAssignments'
  params: {
    location: location
    functionAppName: functionAppName
    apiManagementServiceName: apiManagementServiceName
    keyVaultName: keyVaultName
    keyVaultAdministratorId: keyVaultAdministratorId
  }
  dependsOn: [
    keyVault
  ]
}

module appInsights 'modules/app-insights.bicep' = {
  name: 'appInsights'
  params: {
    location: location
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    appInsightsName: appInsightsName
    retentionInDays: retentionInDays
    keyVaultName: keyVaultName
  }
}

module apiManagement 'modules/api-management.bicep' = {
  name: 'apiManagement'
  params: {
    location: location
    apiManagementServiceName: apiManagementServiceName
    publisherName: apiManagementPublisherName
    publisherEmail: apiManagementPublisherEmail
    apimIdentityName: identitiesAndPermissions.outputs.apimIdentityName
    appInsightsName: appInsightsName
    keyVaultName: keyVaultName
  }
  dependsOn: [
    appInsights
  ]
}
