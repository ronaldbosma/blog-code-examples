# Azure DevOps - Unregister agent from environment

Here's some code to automatically unregister all agents on a server from the correspondending Azure DevOps environment. See the end of the article on how to call this code with Azure CLI from e.g. a YAML pipeline.

```powershell
<#
    .SYNOPSIS
    Removes server from Azure Pipelines environment.

    .DESCRIPTION
    Loops over all agent folders and
    - removes the agent from the Azure Pipelines environment
    - remove the agent folder
    
    .PARAMETER Token
    Personal Access Token. The token needs the scope 'Environment (Read & manage)' in Azure DevOps.

    .EXAMPLE
    PS> .\unregister-server-from-environment.ps1 -Token myToken
#>
param (
    [Parameter(Mandatory)][string]$Token
)


$ErrorActionPreference="Stop";
If(-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent() ).IsInRole( [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    throw "Run command in an administrator PowerShell prompt"
};

If($PSVersionTable.PSVersion -lt (New-Object System.Version("3.0")))
{
    throw "The minimum version of Windows PowerShell that is required by the script (3.0) does not match the currently running version of Windows PowerShell."
};

If(-NOT (Test-Path $env:SystemDrive\'azagent'))
{
    Write-Host "Agent folder $($env:SystemDrive)\azagent not found"
    return;
};


cd $env:SystemDrive\'azagent';

$agentFolders = Get-ChildItem -Directory;
foreach ($agentFolder in $agentFolders)
{
    Write-Host "Unregister agent $agentFolder";
    & .\$agentFolder\config.cmd remove --unattended --auth PAT --token $Token;

    Write-Host "Remove agent folder $agentFolder";
    Remove-Item $agentFolder -Force -Recurse
}
```

## Call unregister script with Azure CLI

If want to execute the unregister script with the Azure CLI, e.g. in a YAML pipeline, then save the code above in e.g. GitHub so it's accessible from the web. Use the filename `unregister-server-from-environment.ps1`.

You can use the following code to call the `unregister-server-from-environment.ps1` script from a YAML pipeline. This code selects all VM's in a resource group and unregisters the agents on the VM's from the corresponding Azure DevOps environments.

```powershell
# Url to the unregister script
$unregisterServerScript = "https://raw.githubusercontent.com/.../unregister-server-from-environment.ps1";
$resourceGroupName = "MyResourceGroup";
$environmentName = "MyEnvironment";
$token = "xyz"; # Azure DevOps Personal Access Token with the scope 'Environment (Read & manage)'

# Get all servers in the resource group
$vms = az vm list --resource-group $resourceGroupName | ConvertFrom-Json | Select-Object -ExpandProperty name;

# Unregister each server from the Azure Pipelines environment
foreach ($vm in $vms)
{
    Write-Host "Unregister $vm from environment";
    $unregisterServerSettings="{`\`"fileUris`\`":[`\`"$unregisterServerScript`\`"], `\`"commandToExecute`\`":`\`"powershell.exe ./unregister-server-from-environment.ps1 -Token '$token'`\`"}";
    az vm extension set `
        --name CustomScriptExtension `
        --publisher Microsoft.Compute `
        --vm-name $vm `
        --resource-group $environmentName `
        --settings $unregisterServerSettings;
}

```