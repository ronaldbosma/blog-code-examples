# Functions based on
# - https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site
# - https://dscottraynsford.wordpress.com/2016/09/10/export-a-base-64-x-509-cert-using-powershell-on-windows-7/
# - https://learn.microsoft.com/en-us/azure/application-gateway/mutual-authentication-certificate-management

function New-SelfSignedRootCACertificate(
    [Parameter(Mandatory=$true)][string]$Subject, 
    [int]$ExpiresInMonths = 36
)
{
    $params = @{
        Type = 'Custom'
        Subject = $Subject
        KeySpec = 'Signature'
        KeyExportPolicy = 'Exportable'
        KeyUsage = 'CertSign'
        KeyUsageProperty = 'Sign'
        KeyLength = 2048
        HashAlgorithm = 'sha256'
        NotAfter = (Get-Date).AddMonths($ExpiresInMonths)
        CertStoreLocation = 'Cert:\CurrentUser\My'
        # This will mark the certificate as a root CA certificate,
        # which is required for it to be uploaded to an Azure Application Gateway
        TextExtension = @('2.5.29.19={text}CA=true')
    }
    return New-SelfSignedCertificate @params
}

function New-SelfSignedIntermediateCACertificate(
    [Parameter(Mandatory=$true)][string]$Subject,
    [Parameter(Mandatory=$true)][System.Security.Cryptography.X509Certificates.X509Certificate2]$Signer, 
    [int]$ExpiresInMonths = 36
)
{
    $params = @{
        Type = 'Custom'
        Subject = $Subject
        KeySpec = 'Signature'
        KeyExportPolicy = 'Exportable'
        KeyUsage = 'CertSign'
        KeyUsageProperty = 'Sign'
        KeyLength = 2048
        HashAlgorithm = 'sha256'
        NotAfter = (Get-Date).AddMonths($ExpiresInMonths)
        CertStoreLocation = 'Cert:\CurrentUser\My'
        Signer = $Signer
        # This will mark the certificate as an intermediate CA certificate
        TextExtension = @('2.5.29.19={text}CA=true&pathlength=1')
    }
    return New-SelfSignedCertificate @params
}

function New-SelfSignedClientCertificate(
    [Parameter(Mandatory=$true)][string]$Subject,
    [Parameter(Mandatory=$true)][string]$DnsName,
    [Parameter(Mandatory=$true)][System.Security.Cryptography.X509Certificates.X509Certificate2]$Signer, 
    [int]$ExpiresInMonths = 12
)
{
    $params = @{
        Type = 'Custom'
        Subject = $Subject
        DnsName = $DnsName
        KeySpec = 'Signature'
        KeyExportPolicy = 'Exportable'
        KeyLength = 2048
        HashAlgorithm = 'sha256'
        NotAfter = (Get-Date).AddMonths($ExpiresInMonths)
        CertStoreLocation = 'Cert:\CurrentUser\My'
        Signer = $Signer
        # This will mark the certificate as a client certificate
        TextExtension = @('2.5.29.37={text}1.3.6.1.5.5.7.3.2')
    }
    return New-SelfSignedCertificate @params
}