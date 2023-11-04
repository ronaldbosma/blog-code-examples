# Settings
$dnsName = 'apim-sample.dev'
$plainTextPassword = 'P@ssw0rd'

# Create self-signed certificate
$params = @{
    DnsName = $dnsName
    CertStoreLocation = 'Cert:\CurrentUser\My'
}
$sslCertificate = New-SelfSignedCertificate @params

# Export the certificate with private key as .pfx file
$certificatePassword = ConvertTo-SecureString -String $plainTextPassword -Force -AsPlainText
$currentScriptPath = $MyInvocation.MyCommand.Path | Split-Path -Parent
Export-PfxCertificate -Cert $sslCertificate -FilePath "$currentScriptPath/ssl-cert.apim-sample.dev.pfx" -Password $certificatePassword