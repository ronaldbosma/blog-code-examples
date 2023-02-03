@description('The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group.')
param workbookDisplayName string = 'My Workbook'

@description('The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is \'workbook\'')
param workbookType string = 'workbook'

@description('The id of resource instance to which the workbook will be associated')
param workbookSourceId string = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-test/providers/microsoft.insights/components/my-application-insights-dev'

@description('The unique guid for this workbook instance')
param workbookId string = newGuid()

resource workbookId_resource 'microsoft.insights/workbooks@2021-03-08' = {
  name: workbookId
  location: resourceGroup().location
  kind: 'shared'
  properties: {
    displayName: workbookDisplayName
    serializedData: '{"version":"Notebook/1.0","items":[{"type":9,"content":{"version":"KqlParameterItem/1.0","parameters":[{"id":"33cdeb0f-d26d-4d93-9c02-e48d32bd1e6d","version":"KqlParameterItem/1.0","name":"Time","type":4,"typeSettings":{"selectableValues":[{"durationMs":300000},{"durationMs":900000},{"durationMs":1800000},{"durationMs":3600000},{"durationMs":14400000},{"durationMs":43200000},{"durationMs":86400000},{"durationMs":172800000},{"durationMs":259200000},{"durationMs":604800000},{"durationMs":1209600000},{"durationMs":2419200000},{"durationMs":2592000000},{"durationMs":5184000000},{"durationMs":7776000000}]},"timeContext":{"durationMs":86400000},"value":{"durationMs":3600000}},{"id":"8f3eff38-d66c-4326-8dce-82e70b76e191","version":"KqlParameterItem/1.0","name":"Subscription","type":2,"multiSelect":true,"quote":"\'","delimiter":",","query":"requests\\r\\n| where customDimensions[\\"Service ID\\"] == \\"my-api-management-dev\\"\\r\\n| project Subscription = tostring(column_ifexists(\'customDimensions\', \'\')[\'Subscription Name\'])\\r\\n| distinct Subscription\\r\\n| sort by Subscription asc","typeSettings":{"additionalResourceOptions":[],"showDefault":false},"timeContext":{"durationMs":0},"timeContextFromParameter":"Time","queryType":0,"resourceType":"microsoft.insights/components"},{"id":"125bb4d9-75cd-4cec-ad46-bfb0e4972005","version":"KqlParameterItem/1.0","name":"Api","type":2,"multiSelect":true,"quote":"\'","delimiter":",","query":"let subscriptionFilter = dynamic([{Subscription}]);\\r\\n\\r\\nrequests\\r\\n| where customDimensions[\\"Service ID\\"] == \\"my-api-management-dev\\"\\r\\n| where array_length(subscriptionFilter) == 0 or customDimensions[\\"Subscription Name\\"] in (subscriptionFilter)\\r\\n| project Api = tostring(column_ifexists(\'customDimensions\', \'\')[\'API Name\'])\\r\\n| distinct Api\\r\\n| sort by Api asc","typeSettings":{"additionalResourceOptions":[],"showDefault":false},"timeContext":{"durationMs":0},"timeContextFromParameter":"Time","queryType":0,"resourceType":"microsoft.insights/components"}],"style":"pills","queryType":0,"resourceType":"microsoft.insights/components"},"name":"parameters - 0"},{"type":3,"content":{"version":"KqlItem/1.0","query":"let subscriptionFilter = dynamic([{Subscription}]);\\r\\nlet apiFilter = dynamic([{Api}]);\\r\\n\\r\\nunion requests\\r\\n| where customDimensions[\\"Service ID\\"] == \\"my-api-management-dev\\"\\r\\n| where array_length(subscriptionFilter) == 0 or customDimensions[\\"Subscription Name\\"] in (subscriptionFilter)\\r\\n| where array_length(apiFilter) == 0 or customDimensions[\\"API Name\\"] in (apiFilter)\\r\\n| project timestamp\\r\\n    , api = customDimensions[\\"API Name\\"]\\r\\n    , name\\r\\n    , subscription = customDimensions[\\"Subscription Name\\"]\\r\\n    , success\\r\\n    , resultCode\\r\\n    , duration\\r\\n    , request = itemId\\r\\n    , trace = itemId\\r\\n| order by timestamp desc","size":2,"timeContextFromParameter":"Time","queryType":0,"resourceType":"microsoft.insights/components"},"name":"query - 1"}],"isLocked":false,"fallbackResourceIds":["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-test/providers/microsoft.insights/components/my-application-insights-dev"]}'
    version: '1.0'
    sourceId: workbookSourceId
    category: workbookType
  }
  dependsOn: []
}

output workbookId string = workbookId_resource.id