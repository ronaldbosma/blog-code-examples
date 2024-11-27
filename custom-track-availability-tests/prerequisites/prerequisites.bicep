//=============================================================================
// Prerequisites
//=============================================================================

//=============================================================================
// Imports
//=============================================================================

import { getResourceName } from './functions/naming-conventions.bicep'


//=============================================================================
// Parameters
//=============================================================================

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.')
param tenantId string = subscription().tenantId

@description('Location to use for all resources')
param location string = resourceGroup().location

@description('The name of the workload to deploy')
@maxLength(12) // The maximum length of the storage account name and key vault name is 24 characters. To prevent errors the workfload name should be short (about 12 characters).
param workload string

@description('The name of the environment to deploy to')
@allowed([
  'dev'
  'tst'
  'acc'
  'prd'
])
param environment string = 'dev'

@description('The instance number to will be added to the deployed resources names to make them unique')
param instance string = '01'

@description('The name of the App Service for the Function App that will be created')
param functionAppServicePlanName string = getResourceName('appServicePlan', workload, environment, location, 'functionapp')

@description('The name of the Function App that will be created')
param functionAppName string = getResourceName('functionApp', workload, environment, location, instance)

@description('Name of the storage account that will be used by the Function App')
@maxLength(24)
param storageAccountName string = getResourceName('storageAccount', workload, environment, location, instance)

@description('The name of the Log Analytics workspace that will be created')
param logAnalyticsWorkspaceName string = getResourceName('logAnalyticsWorkspace', workload, environment, location, instance)

@description('The name of the App Insights instance that will be created and used by API other resources')
param appInsightsName string = getResourceName('applicationInsights', workload, environment, location, instance)

@description('Retention in days of the logging')
param retentionInDays int = 30

@description('The name of the Key Vault that will contain the secrets')
@maxLength(24)
param keyVaultName string = getResourceName('keyVault', workload, environment, location, instance)

@description('The ID of the user that will be granted Key Vault Administrator rights to the Key Vault.')
param keyVaultAdministratorId string

@description('The name of the API Management Service that will be created')
param apiManagementServiceName string = getResourceName('apiManagement', workload, environment, location, instance)

@description('The name of the owner of the API Management service')
param apiManagementPublisherName string = 'admin@example.org'

@description('The email address of the owner of the API Management service')
param apiManagementPublisherEmail string = 'admin@example.org'


//=============================================================================
// Resources
//=============================================================================

module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVault'
  params: {
    tenantId: tenantId
    location: location
    keyVaultName: keyVaultName
  }
}

module storageAccount 'modules/storage-account.bicep' = {
  name: 'storageAccount'
  params: {
    location: location
    storageAccountName: storageAccountName
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
  dependsOn: [
    keyVault
  ]
}

module apiManagement 'modules/api-management.bicep' = {
  name: 'apiManagement'
  params: {
    location: location
    apiManagementServiceName: apiManagementServiceName
    publisherName: apiManagementPublisherName
    publisherEmail: apiManagementPublisherEmail
    apimIdentityName: identitiesAndRoleAssignments.outputs.apimIdentityName
    appInsightsName: appInsightsName
    keyVaultName: keyVaultName
  }
  dependsOn: [
    appInsights
  ]
}

module functionApp 'modules/function-app.bicep' = {
  name: 'functionApp'
  params: {
    location: location
    functionAppServicePlanName: functionAppServicePlanName
    functionAppName: functionAppName
    functionAppIdentityName: identitiesAndRoleAssignments.outputs.functionAppIdentityName
    appInsightsName: appInsightsName
    storageAccountName: storageAccountName
  }
  dependsOn: [
    appInsights
    storageAccount
  ]
}


//=============================================================================
// Resources
//=============================================================================

// Return the names of the resources
output apiManagementServiceName string = apiManagementServiceName
output appInsightsName string = appInsightsName
output functionAppName string = functionAppName
output functionAppServicePlanName string = functionAppServicePlanName
output keyVaultName string = keyVaultName
output logAnalyticsWorkspaceName string = logAnalyticsWorkspaceName
output storageAccountName string = storageAccountName
