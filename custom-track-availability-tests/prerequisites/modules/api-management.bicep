//=============================================================================
// API Management
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('Location to use for all resources')
param location string

@description('The name of the API Management Service that will be created')
param apiManagementServiceName string

@description('The email address of the owner of the API Management service')
param publisherEmail string

@description('The name of the owner of the API Management service')
param publisherName string

@description('The name of the user-assigned managed identity of API management')
param apimIdentityName string

@description('The name of the App Insights instance that will be created and used by API Management')
param appInsightsName string

@description('The name of the Key Vault that will contain the secrets')
@maxLength(24)
param keyVaultName string

//=============================================================================
// Existing resources
//=============================================================================

// APIM User Managed Identity

resource apimIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: apimIdentityName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

//=============================================================================
// Resources
//=============================================================================

// API Management - Consumption tier (see also: https://learn.microsoft.com/en-us/azure/api-management/quickstart-bicep?tabs=CLI)

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: apiManagementServiceName
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${apimIdentity.id}': {}
    }
  }
}


// Store App Insights instrumentation key in named value. Use the secret URI from the Key Vault secret to reference the secret in the named value

resource appInsightsInstrumentationKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' existing = {
  name: 'applicationinsights-instrumentationkey'
  parent: keyVault
}

resource appInsightsInstrumentationKeyNamedValue 'Microsoft.ApiManagement/service/namedValues@2020-06-01-preview' = {
  name: 'appin-instrumentation-key'
  parent: apiManagementService
  properties: {
    displayName: 'appin-instrumentation-key'
    secret: true
    keyVault: {
      secretIdentifier: appInsightsInstrumentationKeySecret.properties.secretUri
      identityClientId: apimIdentity.properties.clientId
    }
  }
}


// Configure API Management to log to App Insights
// - we need a logger that is connected to the App Insights instance
// - we need diagnostics settings that specify what to log to the logger

resource apimAppInsightsLogger 'Microsoft.ApiManagement/service/loggers@2022-08-01' = {
  name: 'apim-appin-logger'
  parent: apiManagementService
  properties: {
    loggerType: 'applicationInsights'
    credentials: {
      // If we would reference the instrumentation key directly using appInsights.properties.InstrumentationKey,
      // a new named value is created everytime we execute a deployment
      instrumentationKey: '{{${appInsightsInstrumentationKeyNamedValue.properties.displayName}}}'
    }
    resourceId: appInsights.id
  }
}

resource apimInsightsDiagnostics 'Microsoft.ApiManagement/service/diagnostics@2022-08-01' = {
  name: 'applicationinsights' // The name of the diagnostics resource has to be applicationinsights, because that's the logger type we chose
  parent: apiManagementService
  properties: {
    alwaysLog: 'allErrors'
    loggerId: apimAppInsightsLogger.id
    httpCorrelationProtocol: 'W3C' // Enable logging to app insights in W3C format
  }
}
