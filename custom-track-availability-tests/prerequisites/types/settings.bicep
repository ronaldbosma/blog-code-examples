@description('The settings for the API Management service')
@export()
type apiManagementSettingsType = {
  @description('The name of the API Management service')
  serviceName: string

  @description('The name of the user-assigned managed identity for the API Management service')
  identityName: string

  @description('The name of the owner of the API Management service')
  publisherName: string

  @description('The email address of the owner of the API Management service')
  publisherEmail: string
}


@description('The settings for the App Insights instance')
@export()
type appInsightsSettingsType = {
  @description('The name of the App Insights instance')
  appInsightsName: string

  @description('The name of the Log Analytics workspace that will be used by the App Insights instance')
  logAnalyticsWorkspaceName: string

  @description('Retention in days of the logging')
  retentionInDays: int
}


@description('The settings for the Function App')
@export()
type functionAppSettingsType = {
  @description('The name of the Function App')
  functionAppName: string

  @description('The name of the user-assigned managed identity for the Function App')
  identityName: string

  @description('The name of the App Service for the Function App')
  appServicePlanName: string

  @description('The .NET Framework version for the Function App')
  netFrameworkVersion: string
}


@description('The settings for the Key Vault')
@export()
type keyVaultSettingsType = {
  @description('The name of the Key Vault')
  keyVaultName: string

  @description('The ID of the user that will be granted Key Vault Administrator rights to the Key Vault')
  keyVaultAdministratorId: string
}
