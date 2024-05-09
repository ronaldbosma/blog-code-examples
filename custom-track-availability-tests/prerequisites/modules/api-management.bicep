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

@description('The name of the App Insights instance that will be created and used by API Management')
param appInsightsName string

//=============================================================================
// Existing resources
//=============================================================================

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
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
    type: 'SystemAssigned'
  }
}


// Store App Insights instrumentation key in named value.
// NOTE: If you want to comply to the Azure Policy "API Management secret named values should be stored in Azure Key Vault",
//       you'll need to store the instrumentation key in Key Vault.

resource appInsightsInstrumentationKeyNamedValue 'Microsoft.ApiManagement/service/namedValues@2020-06-01-preview' = {
  name: 'appin-instrumentation-key'
  parent: apiManagementService
  properties: {
    displayName: 'appin-instrumentation-key'
    value: appInsights.properties.InstrumentationKey
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
    backend: {
      request: {
        headers: [
          'CorrelationId'
        ]
      }
      response: {
        headers: [
          'CorrelationId'
        ]
      }
    }
    frontend: {
      request: {
        headers: [
          'CorrelationId'
        ]
      }
      response: {
        headers: [
          'CorrelationId'
        ]
      }
    }
  }
}
