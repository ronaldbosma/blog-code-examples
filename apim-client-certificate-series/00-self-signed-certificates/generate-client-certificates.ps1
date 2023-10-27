# =====================================================================
# Load functions
# =====================================================================

$currentScriptPath = $MyInvocation.MyCommand.Path | Split-Path -Parent
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