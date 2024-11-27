//=============================================================================
// Function App
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('Location to use for all resources')
param location string

@description('The name of the App Service for the Function App that will be created')
param functionAppServicePlanName string

@description('The name of the Function App that will be created')
param functionAppName string

@description('The name of the user-assigned managed identity of Function App')
param functionAppIdentityName string

@description('Name of the storage account that will be used by the Function App')
param storageAccountName string

@description('The name of the App Insights instance that will be used by the Function App')
param appInsightsName string

//=============================================================================
// Variables
//=============================================================================

var netFrameworkVersion = 'v8.0'
var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'

//=============================================================================
// Existing resources
//=============================================================================

// Function App User Managed Identity

resource functionAppIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: functionAppIdentityName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountName
}

//=============================================================================
// Resources
//=============================================================================

// Create the Application Service Plan for the Function App

resource hostingPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: functionAppServicePlanName
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}


// Create the Function App

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${functionAppIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageAccountConnectionString
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED'
          value: '1'
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
      netFrameworkVersion: netFrameworkVersion
    }
    httpsOnly: true
  }
}
