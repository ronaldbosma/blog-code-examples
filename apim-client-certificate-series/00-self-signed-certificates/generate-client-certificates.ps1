# =====================================================================
# Settings
# =====================================================================

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest


$certificateExpirationInMonths = 600 # 600 months == 50 years


$currentScriptPath = $MyInvocation.MyCommand.Path | Split-Path -Parent
$exportPath = "$currentScriptPath/certificates"
$certificatePassword = ConvertTo-SecureString -String 'P@ssw0rd' -Force -AsPlainText


# =====================================================================
# Load functions
# =====================================================================

. $currentScriptPath/generate-client-certificates.functions.ps1


# =====================================================================
# Generate self-signed certificates
# =====================================================================

$rootCA = New-SelfSignedRootCACertificate -Subject "CN=APIM Sample Root CA" -ExpiresInMonths $certificateExpirationInMonths

# create certificates for dev environment
$devIntermediateCA = New-SelfSignedIntermediateCACertificate -Subject "CN=APIM Sample DEV Intermediate CA" -Signer $rootCA -ExpiresInMonths $certificateExpirationInMonths
$devClient01 = New-SelfSignedClientCertificate -Subject "CN=Client 01" -DnsName "Client 01" -Signer $devIntermediateCA -ExpiresInMonths $certificateExpirationInMonths
$devClient02 = New-SelfSignedClientCertificate -Subject "CN=Client 02" -DnsName "Client 02" -Signer $devIntermediateCA -ExpiresInMonths $certificateExpirationInMonths

# create certificates for tst environment
$tstIntermediateCA = New-SelfSignedIntermediateCACertificate -Subject "CN=APIM Sample TST Intermediate CA" -Signer $rootCA -ExpiresInMonths $certificateExpirationInMonths
$tstClient01 = New-SelfSignedClientCertificate -Subject "CN=Client 01" -DnsName "Client 01" -Signer $tstIntermediateCA -ExpiresInMonths $certificateExpirationInMonths
$tstClient02 = New-SelfSignedClientCertificate -Subject "CN=Client 02" -DnsName "Client 02" -Signer $tstIntermediateCA -ExpiresInMonths $certificateExpirationInMonths


# =====================================================================
# Export self-signed certificates
# =====================================================================

if (-not(Test-Path -Path $exportPath))
{
    New-Item -Path $exportPath -ItemType Directory | Out-Null
}

# Export the certificates without private key as base64 encoded X.509 (.cer) files

Export-CertificateAsBase64 -Certificate $rootCA -OutputFilePath "$exportPath\root-ca.cer"
Export-CertificateAsBase64 -Certificate $rootCA -OutputFilePath "$exportPath\root-ca.without-markers.cer" -ExcludeMarkers

Export-CertificateAsBase64 -Certificate $devIntermediateCA -OutputFilePath "$exportPath\dev-intermediate-ca.cer"
Export-CertificateAsBase64 -Certificate $devIntermediateCA -OutputFilePath "$exportPath\dev-intermediate-ca.without-markers.cer" -ExcludeMarkers
Export-CertificateAsBase64 -Certificate $devClient01 -OutputFilePath "$exportPath\dev-client-01.cer"
Export-CertificateAsBase64 -Certificate $devClient01 -OutputFilePath "$exportPath\dev-client-01.without-markers.cer" -ExcludeMarkers
Export-CertificateAsBase64 -Certificate $devClient02 -OutputFilePath "$exportPath\dev-client-02.cer"

Export-CertificateAsBase64 -Certificate $tstIntermediateCA -OutputFilePath "$exportPath\tst-intermediate-ca.cer"
Export-CertificateAsBase64 -Certificate $tstIntermediateCA -OutputFilePath "$exportPath\tst-intermediate-ca.without-markers.cer" -ExcludeMarkers
Export-CertificateAsBase64 -Certificate $tstClient01 -OutputFilePath "$exportPath\tst-client-01.cer"
Export-CertificateAsBase64 -Certificate $tstClient02 -OutputFilePath "$exportPath\tst-client-02.cer"

# Export the client certificates with private key as .pfx file

Export-PfxCertificate -Cert $devClient01 -FilePath "$exportPath\dev-client-01.pfx" -Password $certificatePassword
Export-PfxCertificate -Cert $devClient02 -FilePath "$exportPath\dev-client-02.pfx" -Password $certificatePassword

Export-PfxCertificate -Cert $tstClient01 -FilePath "$exportPath\tst-client-01.pfx" -Password $certificatePassword
Export-PfxCertificate -Cert $tstClient02 -FilePath "$exportPath\tst-client-02.pfx" -Password $certificatePassword


# =====================================================================
# Combine the base64 encoded X.509 (.cer) files into one file
# =====================================================================

# All (CA) certificates in a certificate chain need to be combined when uploading them in Azure Application Gateway

Merge-Base64CertificateFiles -InputFilePaths @( "$exportPath\dev-intermediate-ca.cer", "$exportPath\root-ca.cer" ) `
                             -OutputFilePath "$exportPath\dev-intermediate-ca-with-root-ca.cer"

Merge-Base64CertificateFiles -InputFilePaths @( "$exportPath\tst-intermediate-ca.cer", "$exportPath\root-ca.cer" ) `
                             -OutputFilePath "$exportPath\tst-intermediate-ca-with-root-ca.cer"
