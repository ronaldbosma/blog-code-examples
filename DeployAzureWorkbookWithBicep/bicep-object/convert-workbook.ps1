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