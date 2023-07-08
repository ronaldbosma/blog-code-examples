# Sample

## Create Self Signed Certificate

Here's an example on how to create a self signed certificate using PowerShell. You'll need elevated privileges to execute the following commands.

```powershell
# Create Self Signed Certificate in My Local Machine Certificate Store
$cert = New-SelfSignedCertificate -DnsName "my-sample-client-certificate" -CertStoreLocation cert:\LocalMachine\My -FriendlyName "My Sample Client Certificate"

# Create password as a secure string
$pwd = ConvertTo-SecureString -String "MyPassword" -Force -AsPlainText

# Export the certificate to a PFX file
Export-PfxCertificate -Cert $cert -FilePath C:\temp\my-sample-client-certificate.pfx -Password $pwd
```
