param appInsightsName string
param apimName string

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

var content = replace(loadTextContent('./ApimRequests.kql'), '##apimName##', apimName)


resource symbolicname 'microsoft.insights/components/analyticsItems@2015-05-01' = {
  name: 'item'
  Scope: 'shared'
  parent: appInsights
  Content: content
  Id: 'apim-requests-function'
  Properties: {
    functionAlias: 'ApimRequests'
  }
}
