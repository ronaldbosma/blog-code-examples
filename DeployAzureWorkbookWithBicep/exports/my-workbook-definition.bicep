{
  version: 'Notebook/1.0'
  items: [
    {
      type: 9
      content: {
        version: 'KqlParameterItem/1.0'
        parameters: [
          {
            id: '33cdeb0f-d26d-4d93-9c02-e48d32bd1e6d'
            version: 'KqlParameterItem/1.0'
            name: 'Time'
            type: 4
            typeSettings: {
              selectableValues: [
                {
                  durationMs: 300000
                }
                {
                  durationMs: 900000
                }
                {
                  durationMs: 1800000
                }
                {
                  durationMs: 3600000
                }
                {
                  durationMs: 14400000
                }
                {
                  durationMs: 43200000
                }
                {
                  durationMs: 86400000
                }
                {
                  durationMs: 172800000
                }
                {
                  durationMs: 259200000
                }
                {
                  durationMs: 604800000
                }
                {
                  durationMs: 1209600000
                }
                {
                  durationMs: 2419200000
                }
                {
                  durationMs: 2592000000
                }
                {
                  durationMs: 5184000000
                }
                {
                  durationMs: 7776000000
                }
              ]
            }
            timeContext: {
              durationMs: 86400000
            }
            value: {
              durationMs: 3600000
            }
          }
          {
            id: '8f3eff38-d66c-4326-8dce-82e70b76e191'
            version: 'KqlParameterItem/1.0'
            name: 'Subscription'
            type: 2
            multiSelect: true
            quote: '\''
            delimiter: ','
            query: 'requests\r\n| where customDimensions["Service ID"] == "${apimResourceName}"\r\n| project Subscription = tostring(column_ifexists(\'customDimensions\', \'\')[\'Subscription Name\'])\r\n| distinct Subscription\r\n| sort by Subscription asc'
            typeSettings: {
              additionalResourceOptions: []
              showDefault: false
            }
            timeContext: {
              durationMs: 0
            }
            timeContextFromParameter: 'Time'
            queryType: 0
            resourceType: 'microsoft.insights/components'
          }
          {
            id: '125bb4d9-75cd-4cec-ad46-bfb0e4972005'
            version: 'KqlParameterItem/1.0'
            name: 'Api'
            type: 2
            multiSelect: true
            quote: '\''
            delimiter: ','
            query: 'let subscriptionFilter = dynamic([{Subscription}]);\r\n\r\nrequests\r\n| where customDimensions["Service ID"] == "${apimResourceName}"\r\n| where array_length(subscriptionFilter) == 0 or customDimensions["Subscription Name"] in (subscriptionFilter)\r\n| project Api = tostring(column_ifexists(\'customDimensions\', \'\')[\'API Name\'])\r\n| distinct Api\r\n| sort by Api asc'
            typeSettings: {
              additionalResourceOptions: []
              showDefault: false
            }
            timeContext: {
              durationMs: 0
            }
            timeContextFromParameter: 'Time'
            queryType: 0
            resourceType: 'microsoft.insights/components'
            value: []
          }
        ]
        style: 'pills'
        queryType: 0
        resourceType: 'microsoft.insights/components'
      }
      name: 'parameters - 0'
    }
    {
      type: 3
      content: {
        version: 'KqlItem/1.0'
        query: 'let subscriptionFilter = dynamic([{Subscription}]);\r\nlet apiFilter = dynamic([{Api}]);\r\n\r\nunion requests\r\n| where customDimensions["Service ID"] == "${apimResourceName}"\r\n| where array_length(subscriptionFilter) == 0 or customDimensions["Subscription Name"] in (subscriptionFilter)\r\n| where array_length(apiFilter) == 0 or customDimensions["API Name"] in (apiFilter)\r\n| project timestamp\r\n    , subscription = customDimensions["Subscription Name"]\r\n    , api = customDimensions["API Name"]\r\n    , name\r\n    , success\r\n    , resultCode\r\n    , duration\r\n    , request = itemId\r\n    , trace = itemId\r\n| order by timestamp desc'
        size: 2
        timeContextFromParameter: 'Time'
        queryType: 0
        resourceType: 'microsoft.insights/components'
        gridSettings: {
          formatters: [
            {
              columnMatch: 'timestamp'
              formatter: 0
              formatOptions: {
                customColumnWidthSetting: '25ch'
              }
            }
            {
              columnMatch: 'subscription'
              formatter: 0
              formatOptions: {
                customColumnWidthSetting: '17ch'
              }
            }
            {
              columnMatch: 'request'
              formatter: 7
              formatOptions: {
                linkTarget: 'RequestDetails'
                linkLabel: 'request'
                linkIsContextBlade: true
              }
            }
            {
              columnMatch: 'trace'
              formatter: 7
              formatOptions: {
                linkTarget: 'TraceDetails'
                linkLabel: 'trace'
              }
            }
          ]
        }
      }
      name: 'query - 1'
    }
  ]
  fallbackResourceIds: [
    '${appInsights.id}'
  ]
  
}
