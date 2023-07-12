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

    # The password of the certificate (as a secure string) to import.
    [Parameter(Mandatory = $true)]
    [Security.SecureString]$CertificatePassword,

    # The file path to the certificate to import.
    [Parameter(Mandatory = $true)]
    [string]$CertificateFilePath
)

$currentCertificate = Get-AzKeyVaultCertificate -VaultName $keyVaultName -Name $certificateName
$certificateExistsInKeyVault = $null -ne $currentCertificate

if ($certificateExistsInKeyVault)
{
    $certificateToImport = Get-PfxCertificate -FilePath $CertificateFilePath -Password $CertificatePassword
    $thumbprintIsDifferent = $certificateToImport.Thumbprint -ne $currentCertificate.Thumbprint

    Write-Host "Is thumbprint of '$CertificateName' in Key Vault '$KeyVaultName' different from '$CertificateFilePath': $thumbprintIsDifferent"
}
else
{
    Write-Host "Certificate '$CertificateName' does not exist in Key Vault '$KeyVaultName'"
}

if (-not($certificateExistsInKeyVault) -or $thumbprintIsDifferent)
{
    Write-Host "Import certificate '$CertificateName' into Key Vault '$KeyVaultName'"
    Import-AzKeyVaultCertificate -VaultName $KeyVaultName `
                                 -Name $CertificateName `
                                 -FilePath $CertificateFilePath `
                                 -Password $CertificatePassword
}
else
{
    Write-Host "Skipped import of certificate '$CertificateName' into Key Vault '$KeyVaultName'"
}