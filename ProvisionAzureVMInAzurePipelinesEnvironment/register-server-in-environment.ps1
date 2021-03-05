<#
    .SYNOPSIS
    Register server in Azure Pipelines environment.

    .DESCRIPTION
    Downloads and installs agent on the server and then registers the server in an Azure Pipelines environment.
    This script is based on the registration script that you can copy from the Azure DevOps portal when manually adding a Virtual machine resource to an environment.

    .PARAMETER OrganizationUrl
    URL of the organization. For example: https://myaccount.visualstudio.com or http://onprem:8080/tfs.

    .PARAMETER TeamProject
    Name of the team project. For example myProject.

    .PARAMETER Environment
    Name of the environment. For example: myEnvironment.

    .PARAMETER Token
    Personal Access Token. The token needs the scope 'Environment (Read & manage)' in Azure DevOps.

    .PARAMETER Tags
    Optional comma separated list of tags to add to the server. For example: "web, sql".

    .EXAMPLE
    PS> .\register-server-in-environment.ps1 -OrganizationUrl https://myaccount.visualstudio.com -TeamProject myProject -Environment myEnvironment -Token myToken

    .EXAMPLE
    PS> .\register-server-in-environment.ps1 -OrganizationUrl https://myaccount.visualstudio.com -TeamProject myProject -Environment myEnvironment -Token myToken -Tags "web, sql"
#>
param (
    [Parameter(Mandatory)][string]$OrganizationUrl,
    [Parameter(Mandatory)][string]$TeamProject,
    [Parameter(Mandatory)][string]$Environment,
    [Parameter(Mandatory)][string]$Token,
    [string]$Tags
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
    mkdir $env:SystemDrive\'azagent'
};


$agentName = $env:COMPUTERNAME;

cd $env:SystemDrive\'azagent';

# Create a unique A* folder for the agent using i as the index
for($i=1; $i -lt 100; $i++)
{
    $destFolder="A"+$i.ToString();
    if(-NOT (Test-Path ($destFolder)))
    {
        mkdir $destFolder;
        cd $destFolder;

        $agentName = "$agentName-$i";

        break;
    }
};

$agentZip="$PWD\agent.zip";


# Configure the web client used to download the zip file with the agent
$DefaultProxy=[System.Net.WebRequest]::DefaultWebProxy;
$securityProtocol=@();
$securityProtocol+=[Net.ServicePointManager]::SecurityProtocol;
$securityProtocol+=[Net.SecurityProtocolType]::Tls12;
[Net.ServicePointManager]::SecurityProtocol=$securityProtocol;
$WebClient=New-Object Net.WebClient; 
$WebClient.Headers.Add("user-agent", "azure pipeline");


## Retrieve list with releases for the Azure Pipelines agent
$releasesUrl = "https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases"
if($DefaultProxy -and (-not $DefaultProxy.IsBypassed($releasesUrl)))
{
    $WebClient.Proxy= New-Object Net.WebProxy($DefaultProxy.GetProxy($releasesUrl).OriginalString, $True);
};
$releases = $WebClient.DownloadString($releasesUrl) | ConvertFrom-Json


## Select the newest agent release
$latestAgentRelease = $releases | Sort-Object -Property published_at -Descending | Select-Object -First 1
$assetsUrl = $latestAgentRelease.assets[0].browser_download_url


## Get the agent download url from the agent release assets
if($DefaultProxy -and (-not $DefaultProxy.IsBypassed($assetsUrl)))
{
    $WebClient.Proxy= New-Object Net.WebProxy($DefaultProxy.GetProxy($assetsUrl).OriginalString, $True);
};
$assets = $WebClient.DownloadString($assetsUrl) | ConvertFrom-Json
$Uri = $assets | Where-Object { $_.platform -eq "win-x64"} | Select-Object -First 1 | Select-Object -ExpandProperty downloadUrl


# Download the zip file with the agent
if($DefaultProxy -and (-not $DefaultProxy.IsBypassed($Uri)))
{
    $WebClient.Proxy= New-Object Net.WebProxy($DefaultProxy.GetProxy($Uri).OriginalString, $True);
};
Write-Host "Download agent zip file from $Uri";
$WebClient.DownloadFile($Uri, $agentZip);


# Extract the zip file
Add-Type -AssemblyName System.IO.Compression.FileSystem;
[System.IO.Compression.ZipFile]::ExtractToDirectory( $agentZip, "$PWD");

# Remove the zip file
Remove-Item $agentZip;


# Register the agent in the environment
Write-Host "Register agent $agentName in $Environment";
if ([string]::IsNullOrWhiteSpace($Tags))
{
    .\config.cmd --unattended --environment --environmentname $Environment --agent $agentName --runasservice --work '_work' --url $OrganizationUrl --projectname $TeamProject --auth PAT --token $Token;
}
else
{
    .\config.cmd --unattended --environment --environmentname $Environment --agent $agentName --runasservice --work '_work' --url $OrganizationUrl --projectname $TeamProject --auth PAT --token $Token --addvirtualmachineresourcetags --virtualmachineresourcetags "$($Tags)";
}


# Raise an exception if the registration of the agent failed
if ($LastExitCode -ne 0)
{
    throw "Error during registration. See '$PWD\_diag' for more information.";
}