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


// Virtual Network
module virtualNetwork './virtual-network/virtual-network.bicep' = {
  name: 'virtualNetwork'
  params: {
    location: location
  }
}

// API Management
module apiManagement './api-management/api-management.bicep' = {
  name: 'apiManagement'
  params: {
    apiManagementServiceName: apiManagementServiceName
    location: location
    publisherEmail: publisherEmail
    publisherName: publisherName
    subnetId: virtualNetwork.outputs.apimSubnetId
  }
}


// Application Gateway
module appGateway './application-gateway/application-gateway.bicep' = {
  name: 'appGateway'
  params: {
    applicationGatewayName: 'agw-validate-client-certificate'
    location: location
    subnetId: virtualNetwork.outputs.agwSubnetId
    apiManagementServiceName: apiManagementServiceName
    apiManagementIPAddress: apiManagement.outputs.apiManagementIPAddress
  }
}
