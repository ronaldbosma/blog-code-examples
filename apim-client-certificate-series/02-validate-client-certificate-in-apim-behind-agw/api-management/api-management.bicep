//=============================================================================
// Azure API Management
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

@description('The ID of the subnet to use for the API Management service')
param subnetId string

//=============================================================================
// Resources
//=============================================================================


// API Management Public IP address
resource apimPublicIPAddress 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: 'pip-apim-validate-client-certificate'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      // The label you choose to use does not matter but a label is required if this resource will be assigned to an API Management service.
      domainNameLabel: apiManagementServiceName
    }
  }
}


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
    virtualNetworkType: 'Internal'
    virtualNetworkConfiguration: {
      subnetResourceId: subnetId
    }
    publicIpAddressId: apimPublicIPAddress.id
    certificates: [
      {
        encodedCertificate: loadTextContent('../../00-self-signed-certificates/certificates/root-ca.without-markers.cer')
        storeName: 'Root'
      }
      {
        encodedCertificate: loadTextContent('../../00-self-signed-certificates/certificates/dev-intermediate-ca.without-markers.cer')
        storeName: 'CertificateAuthority'
      }
    ]
  }
}


// Add client certificate for 'Dev Client 01'
resource devClient01Certificate 'Microsoft.ApiManagement/service/certificates@2022-08-01' = {
  name: 'dev-client-01'
  parent: apiManagementService
  properties: {
    data: loadTextContent('../../00-self-signed-certificates/certificates/dev-client-01.without-markers.cer')
  }
}


// Client Cert API
resource clientCertApi 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: 'client-cert-api'
  parent: apiManagementService
  properties: {
    displayName: 'Client Cert API'
    path: 'client-cert'
    protocols: [ 
      'https' 
    ]
    subscriptionRequired: false
  }
}


// Operation to validate client certificate using validate-client-certificate policy
resource validateUsingPolicy 'Microsoft.ApiManagement/service/apis/operations@2022-08-01' = {
  name: 'validate-using-policy'
  parent: clientCertApi
  properties: {
    displayName: 'Validate (using policy)'
    description: 'Validates client certificate using validate-client-certificate policy'
    method: 'GET'
    urlTemplate: '/validate-using-policy'
  }

  resource policies 'policies' = {
    name: 'policy'
    properties: {
      format: 'rawxml'
      value: loadTextContent('./validate-using-policy.operation.cshtml') 
    }
  }
}


// Operation to validate client certificate using context.Request.Certificate property
resource validateUsingContext 'Microsoft.ApiManagement/service/apis/operations@2022-08-01' = {
  name: 'validate-using-context'
  parent: clientCertApi
  properties: {
    displayName: 'Validate (using context)'
    description: 'Validates client certificate using the context.Request.Certificate property'
    method: 'GET'
    urlTemplate: '/validate-using-context'
  }

  resource policies 'policies' = {
    name: 'policy'
    properties: {
      format: 'rawxml'
      value: loadTextContent('./validate-using-context.operation.cshtml') 
    }
  }
}


// Operation to validate client certificate received from Application Gateway
resource validateFromAppGateway 'Microsoft.ApiManagement/service/apis/operations@2022-08-01' = {
  name: 'validate-from-agw'
  parent: clientCertApi
  properties: {
    displayName: 'Validate (from AGW)'
    description: 'Validates client certificate received from Application Gateway'
    method: 'GET'
    urlTemplate: '/validate-from-agw'
  }

  resource policies 'policies' = {
    name: 'policy'
    properties: {
      format: 'rawxml'
      value: loadTextContent('./validate-from-agw.operation.cshtml') 
    }
  }
}


//=============================================================================
// Outputs
//=============================================================================

output apiManagementIPAddress string = apiManagementService.properties.privateIPAddresses[0]
