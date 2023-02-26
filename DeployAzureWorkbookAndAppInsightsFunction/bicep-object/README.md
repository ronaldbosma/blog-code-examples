# Deploy Workbook with Bicep object

You can convert the workbook JSON definition into a Bicep object. It can be used inside the Bicep script and can be formatted for improved readability. 

The first step is to download the workbook definition. Open the workbook in Edit mode and click the Advanced Editor button.

Choose Gallery Template as the Template Type and download the template. The result will be a JSON file containing only the definition of the workbook. See [sample.workbook](./sample.workbook) for a sample.

To use this definition in the Bicep script, we need to convert the JSON to valid Bicep. I've created the following PowerShell script to do this.

```powershell
$sourceFile = "./sample.workbook"
$targetFile = "./sample-object.bicep"

# Key value pair of environment specific values and the param/variable names that should replace them
$variables = @{
    "my-api-management-dev" = "apimResourceName";
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-test/providers/microsoft.insights/components/my-application-insights-dev" = "appInsights.id";
}

$workbook = Get-Content -Path $sourceFile

# For each line in the workbook
for ($i = 0; $i -lt $workbook.Count; $i++)
{
    # 1. Remove " surrounding the property names
    $workbook[$i] = $workbook[$i] -replace '"([a-zA-Z0-9/-/$]+)":', '$1:'

    # 2. Replace ' with \` so the ` is escaped in values
    $workbook[$i] = $workbook[$i] -replace "'", "\'"

    # 3. Replace " surrounding the values with ' and remove the trailing ,
    $workbook[$i] = $workbook[$i] -replace '"(.*)",?$', '''$1'''

    # 4. Remove leftover trailing ,
    $workbook[$i] = $workbook[$i] -replace ',$', ''

    # 5. Put a space in front of the first [ in a string value to prevent deployment errors
    $workbook[$i] = $workbook[$i] -replace '''\[(.*)''$', ''' [$1'''

    # 6. Replace \" with ". No need to escape the " in values because the values are surrounded with ' instead of "
    $workbook[$i] = $workbook[$i] -replace '\\"', '"'

    # 7. Remove the JSON schema reference
    $workbook[$i] = $workbook[$i].Replace("`$schema: 'https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json'", "")

    # 8. Replace environment specific values with variables
    foreach ($valueToReplace in $variables.Keys)
    {
        $workbook[$i] = $workbook[$i] -replace $valueToReplace ,"`${$($variables[$valueToReplace])}"
    }
}

Set-Content -Path $targetFile -Value $workbook
```

When this script is executed, the `sample.workbook` file is loaded, and we loop over every line performing the following transformations:
1. Remove the `"` that surrounds the property names. Bicep properties don't have these.
2. Escape all occurrences of `'` with a \`. This will escape for instance a `'` that is used in a query.
3. Surround string values with `'` instead of `"` and remove any trailing `,`
4. Remove all trailing `,` that were skipped by the previous step (in case of non-string value for example)
5. If the value is a JSON array that starts with `[`, the deployment somehow fails. Adding a white space in front of the `[` fixes the issue.
6. Remove the `\` from `\"`. The `"` in values was escaped, but this is no longer necessary since the values are surround by a `'`
7. Remove the JSON schema property
8. Replace all environment specific values with variables/parameters. E.g. the value `my-api-management-dev` becomes `${apimResourceName}` for example.

The result is a Bicep file that looks like [sample-object.bicep](./sample-object.bicep).

You can put the contents of the generated definition file in the following Bicep script as the value of the `definition` variable.

```bicep
param name string = 'sample-workbook'
param displayName string = 'Sample Workbook'
param appInsightsName string

var definition = //PUT YOUR GENERATED BICEP OBJECT HERE

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource workbookId_resource 'microsoft.insights/workbooks@2021-03-08' = {
  name: guid(name)
  location: resourceGroup().location
  kind: 'shared'
  properties: {
    displayName: displayName
    serializedData: string(definition)
    version: '1.0'
    sourceId: appInsights.id
    category: 'workbook'
  }
}
```

As you can see, the definition is first converted with the `string()` function before setting the `serializedData` property. After saving the Bicep file, it should look like [sample.bicep](./sample.bicep).

Because the workbook definition is formatted instead of a one liner string, it's easier to make small changes or see what was changed.

You can now deploy the workbook using the following Azure CLI command and you're done.

```powershell
$resourceGroupName = '<resource group>'
$applicationInsightsName = '<application insights name>'

az deployment group create `
    --name 'sample-workbook-deployment' `
    --resource-group $resourceGroupName `
    --template-file './sample.bicep' `
    --parameters appInsightsName=$applicationInsightsName `
    --verbose
```