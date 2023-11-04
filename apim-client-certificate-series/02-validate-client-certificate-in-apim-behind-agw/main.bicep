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
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: 'vnet-validate-client-certificate'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-app-gateway'
        properties: {
          addressPrefix: '10.0.0.0/24'
          // privateEndpointNetworkPolicies: 'Enabled'
          // privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'snet-api-management'
        properties: {
          addressPrefix: '10.0.1.0/24'
          // privateEndpointNetworkPolicies: 'Enabled'
          // privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
    enableVmProtection: false
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
  }
}
