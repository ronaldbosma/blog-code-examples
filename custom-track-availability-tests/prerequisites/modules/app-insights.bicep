//=============================================================================
// Application Insights
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('Location to use for all resources')
param location string

@description('The name of the Log Analytics workspace that will be created')
param logAnalyticsWorkspaceName string

@description('The name of the App Insights instance that will be created and used by other resources')
param appInsightsName string

@description('Retention in days of the logging')
param retentionInDays int = 30

@description('The name of the Key Vault that will contain the secrets')
@maxLength(24)
param keyVaultName string

//=============================================================================
// Existing Resources
//=============================================================================

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

//=============================================================================
// Resources
//=============================================================================

// Log Analytics Workspace

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    retentionInDays: retentionInDays
    sku: {
      name: 'Standalone'
    }
  }
}


// Application Insights

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    WorkspaceResourceId: logAnalyticsWorkspace.id
    RetentionInDays: retentionInDays
  }
}


// Store secrets in Key Vault

resource appInsightsInstrumentationKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'applicationinsights-instrumentationkey'
  parent: keyVault
  properties: {
    value: appInsights.properties.InstrumentationKey
  }
}

resource appInsightsConnectionStringSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'applicationinsights-connectionstring'
  parent: keyVault
  properties: {
    value: appInsights.properties.ConnectionString
  }
}
