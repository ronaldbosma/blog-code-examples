//=============================================================================
// Prerequisites
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

// API Management

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: apiManagementServiceName
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

// API

resource clientCertApi 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: 'client-cert-api'
  parent: apiManagementService
  properties: {
    displayName: 'Client Cert API'
    path: 'client-cert'
    protocols: [ 
      'https' 
    ]
  }

  // Validate operation
  resource validate 'operations' = {
    name: 'validate'
    properties: {
      displayName: 'Validate'
      method: 'GET'
      urlTemplate: '/validate'
    }

    resource policies 'policies' = {
      name: 'policy'
      properties: {
        format: 'rawxml'
        value: loadTextContent('./validate.operation.cshtml') 
      }
    }
  }
}
