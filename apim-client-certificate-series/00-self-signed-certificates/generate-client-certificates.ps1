# =====================================================================
# Settings
# =====================================================================

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest


$currentScriptPath = $MyInvocation.MyCommand.Path | Split-Path -Parent
$exportPath = "$currentScriptPath/certificates"


# =====================================================================
# Load functions
# =====================================================================

. $currentScriptPath/generate-client-certificates.functions.ps1


# =====================================================================
# Generate self-signed certificates
# =====================================================================

$rootCA = New-SelfSignedRootCACertificate -Subject "CN=APIM Sample Root CA"

# create certificates for dev environment
$devIntermediateCA = New-SelfSignedIntermediateCACertificate -Subject "CN=APIM Sample DEV Intermediate CA" -Signer $rootCA
$devClient01 = New-SelfSignedClientCertificate -Subject "CN=Client 01" -DnsName "Client 01" -Signer $devIntermediateCA
$devClient02 = New-SelfSignedClientCertificate -Subject "CN=Client 02" -DnsName "Client 02" -Signer $devIntermediateCA

# create certificates for tst environment
$tstIntermediateCA = New-SelfSignedIntermediateCACertificate -Subject "CN=APIM Sample TST Intermediate CA" -Signer $rootCA
$tstClient01 = New-SelfSignedClientCertificate -Subject "CN=Client 01" -DnsName "Client 01" -Signer $tstIntermediateCA
$tstClient02 = New-SelfSignedClientCertificate -Subject "CN=Client 02" -DnsName "Client 02" -Signer $tstIntermediateCA


# =====================================================================
# Export self-signed certificates
# =====================================================================

if (-not(Test-Path -Path $exportPath))
{
    New-Item -Path $exportPath -ItemType Directory | Out-Null
}

Export-CertificateAsBase64 -Certificate $rootCA -OutputFilePath "$exportPath\root-ca.cer"

Export-CertificateAsBase64 -Certificate $devIntermediateCA -OutputFilePath "$exportPath\dev-intermediate-ca.cer"
Export-CertificateAsBase64 -Certificate $devClient01 -OutputFilePath "$exportPath\dev-client-01.cer"
Export-CertificateAsBase64 -Certificate $devClient02 -OutputFilePath "$exportPath\dev-client-02.cer"

Export-CertificateAsBase64 -Certificate $tstIntermediateCA -OutputFilePath "$exportPath\tst-intermediate-ca.cer"
Export-CertificateAsBase64 -Certificate $tstClient01 -OutputFilePath "$exportPath\tst-client-01.cer"
Export-CertificateAsBase64 -Certificate $tstClient02 -OutputFilePath "$exportPath\tst-client-02.cer"