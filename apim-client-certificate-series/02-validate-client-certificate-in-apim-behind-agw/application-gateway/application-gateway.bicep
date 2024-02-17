//=============================================================================
// Application Gateway
//=============================================================================


//=============================================================================
// Parameters
//=============================================================================

@description('The name of the application gateway to create')
param applicationGatewayName string

@description('Location to use for all resources')
param location string = resourceGroup().location

@description('The ID of the subnet to use for the API Management service')
param subnetId string

@description('The name of the API Management Service to use')
param apiManagementServiceName string

@description('The IP address of the API Management Service to use')
param apiManagementIPAddress string

//=============================================================================
// Resources
//=============================================================================


// Public IP address
resource agwPublicIPAddress 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: 'pip-agw-validate-client-certificate'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}


// Application Gateway
resource applicationGateway 'Microsoft.Network/applicationGateways@2023-05-01' = {
  name: applicationGatewayName
  location: location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
    enableHttp2: false
    autoscaleConfiguration: {
      minCapacity: 0
      maxCapacity: 2
    }

    gatewayIPConfigurations: [
      {
        name: 'agw-subnet-ip-config'
        properties: {
          subnet: {
            id: subnetId
          }
        }
      }
    ]


    // Frontend

    frontendIPConfigurations: [
      {
        name: 'agw-public-frontend-ip'
        properties: {
          publicIPAddress: {
            id: agwPublicIPAddress.id
          }
        }
      }
    ]

    frontendPorts: [
      {
        name: 'port-https'
        properties: {
          port: 443
        }
      }
      {
        name: 'port-mtls'
        properties: {
          port: 53029
        }
      }
    ]

    sslCertificates: [
      {
        name: 'agw-ssl-certificate'
        properties: {
          data: loadFileAsBase64('./ssl-cert.apim-sample.dev.pfx')
          password: 'P@ssw0rd'
        }
      }
    ]

    trustedClientCertificates: [
      {
        name: 'intermediate-ca-with-root-ca'
        properties: {
          data: loadTextContent('../../00-self-signed-certificates/certificates/dev-intermediate-ca-with-root-ca.cer')
        }
      }
    ]

    sslProfiles: [
      {
        name: 'mtls-ssl-profile'
        properties: {
          clientAuthConfiguration: {
            // By setting verifyClientCertIssuerDN to true the intermediate CA is also checked, not just the Root CA.
            // See https://learn.microsoft.com/en-us/azure/application-gateway/mutual-authentication-overview?tabs=powershell#verify-client-certificate-dn
            verifyClientCertIssuerDN: true
          }
          trustedClientCertificates: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/trustedClientCertificates', applicationGatewayName, 'intermediate-ca-with-root-ca')
            }
          ]
        }
      }
    ]

    httpListeners: [
      {
        name: 'https-listener'
        properties: {
          protocol: 'Https'
          hostName: 'apim-sample.dev'
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'agw-public-frontend-ip')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'port-https')
          }
          sslCertificate: {
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', applicationGatewayName, 'agw-ssl-certificate')
          }
        }
      }
      {
        name: 'mtls-listener'
        properties: {
          protocol: 'Https'
          hostName: 'apim-sample.dev'
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'agw-public-frontend-ip')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'port-mtls')
          }
          sslCertificate: {
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', applicationGatewayName, 'agw-ssl-certificate')
          }
          sslProfile: {
            id: resourceId('Microsoft.Network/applicationGateways/sslProfiles', applicationGatewayName, 'mtls-ssl-profile')
          }
        }
      }
    ]


    // Backend

    backendAddressPools: [
      {
        name: 'apim-gateway-backend-pool'
        properties: {
          backendAddresses: [
            {
              ipAddress: apiManagementIPAddress
            }
          ]
        }
      }
    ]

    probes: [
      {
        name: 'apim-gateway-probe'
        properties: {
          pickHostNameFromBackendHttpSettings: true
          interval: 30
          timeout: 30
          path: '/status-0123456789abcdef'
          protocol: 'Https'
          unhealthyThreshold: 3
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
    ]
    
    backendHttpSettingsCollection: [
      {
        name: 'apim-gateway-backend-settings'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          hostName: '${apiManagementServiceName}.azure-api.net'
          requestTimeout: 20
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', applicationGatewayName, 'apim-gateway-probe')
          }
        }
      }
    ]


    // Rules
    
    rewriteRuleSets: [
      {
        name: 'default-rewrite-rules'
        properties: {
          rewriteRules: [
            {
              ruleSequence: 100
              conditions: []
              name: 'Remove X-ARR-ClientCert HTTP header'
              actionSet: {
                requestHeaderConfigurations: [
                  // We need to remove the client certificate header from the default listener,
                  // to prevent clients from tricking APIM into thinking a successful mTLS connection was established.
                  {
                    headerName: 'X-ARR-ClientCert'
                    headerValue: ''
                  }
                ]
                responseHeaderConfigurations: []
              }
            }
          ]
        }
      }
      {
        name: 'mtls-rewrite-rules'
        properties: {
          rewriteRules: [
            {
              ruleSequence: 100
              conditions: []
              name: 'Add Client certificate to HTTP header'
              actionSet: {
                requestHeaderConfigurations: [
                  {
                    headerName: 'X-ARR-ClientCert'
                    headerValue: '{var_client_certificate}'
                  }
                ]
                responseHeaderConfigurations: []
              }
            }
          ]
        }
      }
    ]

    requestRoutingRules: [
      {
        name: 'apim-https-routing-rule'
        properties: {
          priority: 20
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'https-listener')
          }
          rewriteRuleSet: {
            id: resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', applicationGatewayName, 'default-rewrite-rules')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'apim-gateway-backend-pool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'apim-gateway-backend-settings')
          }
        }
      }
      {
        name: 'apim-mtls-routing-rule'
        properties: {
          priority: 30
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'mtls-listener')
          }
          rewriteRuleSet: {
            id: resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', applicationGatewayName, 'mtls-rewrite-rules')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'apim-gateway-backend-pool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'apim-gateway-backend-settings')
          }
        }
      }
    ]
  }
}
