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

@description('The name of the App Insights instance that will be created and used by API Management')
param appInsightsName string

@description('Retention in days of the logging')
param retentionInDays int = 30

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
