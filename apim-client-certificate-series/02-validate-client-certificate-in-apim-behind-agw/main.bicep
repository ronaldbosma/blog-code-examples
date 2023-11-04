//=============================================================================
// Validate Client Certificate in API Management behind Application Gateway
//=============================================================================


//=============================================================================
// Parameters
//=============================================================================


@description('The name of the API Management Service that will be created')
param apiManagementServiceName string

@description('Location to use for all resources')
param location string = resourceGroup().location

@description('The email address of the owner of the API Management service')
param publisherEmail string

@description('The name of the owner of the API Management service')
param publisherName string


//=============================================================================
// Resources
//=============================================================================


module apiManagement './api-management/api-management.bicep' = {
  name: 'apiManagement'
  params: {
    apiManagementServiceName: apiManagementServiceName
    location: location
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}
