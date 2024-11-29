//=============================================================================
// Prerequisites
//=============================================================================

//=============================================================================
// Imports
//=============================================================================

import { getResourceName, getResourceIdentityName } from './functions/naming-conventions.bicep'
import * as settings from './types/settings.bicep'


//=============================================================================
// Parameters
//=============================================================================

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.')
param tenantId string = subscription().tenantId

@description('Location to use for all resources')
param location string = resourceGroup().location

@description('The name of the workload to deploy')
@maxLength(12) // The maximum length of the storage account name and key vault name is 24 characters. To prevent errors the workload name should be short (about 12 characters).
param workload string

@description('The name of the environment to deploy to')
@allowed([
  'dev'
  'tst'
  'acc'
  'prd'
])
param environment string

@description('The instance number to will be added to the deployed resources names to make them unique')
param instance string

@description('The ID of the user that will be granted Key Vault Administrator rights to the Key Vault.')
param keyVaultAdministratorId string


//=============================================================================
// Variables
//=============================================================================

var apiManagementSettings = {
  serviceName: getResourceName('apiManagement', workload, environment, location, instance)
  identityName: getResourceIdentityName('apiManagement', workload, environment, location, instance)
  publisherName: 'admin@example.org'
  publisherEmail: 'admin@example.org'
}

var appInsightsSettings = {
  appInsightsName: getResourceName('applicationInsights', workload, environment, location, instance)
  logAnalyticsWorkspaceName: getResourceName('logAnalyticsWorkspace', workload, environment, location, instance)
  retentionInDays: 30
}

var functionAppSettings = {
  functionAppName: getResourceName('functionApp', workload, environment, location, instance)
  identityName: getResourceIdentityName('functionApp', workload, environment, location, instance)
  appServicePlanName: getResourceName('appServicePlan', workload, environment, location, 'functionapp-${instance}')
  netFrameworkVersion: 'v8.0'
}

var keyVaultName = getResourceName('keyVault', workload, environment, location, instance)

var storageAccountName = getResourceName('storageAccount', workload, environment, location, instance)


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
    functionAppIdentityName: functionAppSettings.identityName
    apiManagementIdentityName: apiManagementSettings.identityName
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
    appInsightsSettings: appInsightsSettings
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
    apiManagementSettings: apiManagementSettings
    appInsightsName: appInsightsSettings.appInsightsName
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
    functionAppSettings: functionAppSettings
    appInsightsName: appInsightsSettings.appInsightsName
    storageAccountName: storageAccountName
  }
  dependsOn: [
    appInsights
    storageAccount
  ]
}


//=============================================================================
// Outputs
//=============================================================================

// Return the names of the resources
output apiManagementServiceName string = apiManagementSettings.serviceName
output appInsightsName string = appInsightsSettings.appInsightsName
output functionAppName string = functionAppSettings.functionAppName
output functionAppServicePlanName string = functionAppSettings.appServicePlanName
output keyVaultName string = keyVaultName
output logAnalyticsWorkspaceName string = appInsightsSettings.logAnalyticsWorkspaceName
output storageAccountName string = storageAccountName
