<#
    Will import a certificate into Key Vault if it does not exist or if the thumprint does not match.
#>
[CmdletBinding()]
param
(
    # The name of the Azure Key Vault to import the certificate to.
    [Parameter(Mandatory = $true)]
    [string]$KeyVaultName,

    # The name of the certificate inside Azure Key Vault.
    [Parameter(Mandatory = $true)]
    [string]$CertificateName,

    # The password of the certificate (as a secure string).
    [Parameter(Mandatory = $true)]
    [Security.SecureString]$CertificatePassword,

    # The path to the certificate file to import
    [Parameter(Mandatory = $true)]
    [string]$CertificateFilePath
)

$shouldImportCertificate = $true

# Retrieve the thumprint of the existing certificate. Will be $null if the certificate does not exist.
$existingThumprint = az keyvault certificate show --name $CertificateName --vault-name $KeyVaultName --query "x509ThumbprintHex" -o tsv
$currentCertificate = az keyvault certificate show --name $CertificateName --vault-name $KeyVaultName --query "x509ThumbprintHex" -o tsv

# If the certificate exists, check if the thumbprint of the existing certificate is the same as the thumbprint of the certificate to import.
if ($null -ne $existingThumprint)
{
    $cert = Get-PfxCertificate -FilePath $CertificateFilePath -Password $CertificatePassword
    $shouldImportCertificate = $cert.Thumbprint -ne $existingThumprint

    Write-Host "Does thumbprint of $CertificateName in Key $KeyVaultName match thumbprint of '$CertificateFilePath': $(-not($shouldImportCertificate))"
}
else
{
    Write-Host "Certificate $CertificateName does not exist in Key Vault $KeyVaultName."
}

# Import the certificate if it doesn't exist or if the thumbprint did not match.
if ($shouldImportCertificate)
{
    Write-Host "Import certificate $CertificateName into Key Vault $KeyVaultName."

    Import-AzKeyVaultCertificate -VaultName $KeyVaultName `
                                 -Name $CertificateName `
                                 -FilePath $CertificateFilePath `
                                 -Password $CertificatePassword

    # az keyvault certificate import `
    #     --file $CertificateFilePath `
    #     --vault-name $KeyVaultName `
    #     --name $CertificateName `
    #     --password $CertificatePassword
}