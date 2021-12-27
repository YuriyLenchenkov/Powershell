#Powershell WinSCP required

#Import WinSCP Module if needed
#module installation if needed
#Install-Module -Name WinSCP -RequiredVersion 5.17.10.0 -Scope AllUsers -Force


#Deleting old backups
Get-ChildItem C:\backup\apps_backup\appps_backup*.zip| Where-Object {$_.CreationTime -gt (Get-Date).AddDays(-45) -and $_.CreationTime -lt (Get-Date).AddDays(-15)} | Remove-Item -Force

$compress = @{
LiteralPath= "C:\apps"
CompressionLevel = "Fastest"
DestinationPath = "C:\backup\apps_backup\apps_backup_$(Get-Date -Format "yyyyMMdd").zip"
}
Compress-Archive @compress -Force

Import-Module WinSCP

# Create Credential Object
$username = "some_svc_acc"                                                                                              
$password = ConvertTo-SecureString "some_pass" -AsPlainText -Force                                                 
$credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $password 

#Set Target Hostname
$Hostname = "some_ip"           

#Paths
$LocalPath = "src_path"
$RemotePath = "dst_path"


# Create new WinSCP session using captured credentials.
$sessionOption = New-WinSCPSessionOption -HostName $Hostname -PortNumber 22 -Credential $credential -GiveUpSecurityAndAcceptAnySshHostKey #-GiveUpSecurityAndAcceptAnyTlsHostCertificate
$session = New-WinSCPSession -SessionOption $sessionOption

# Upload a file to the directory.
sync-winscppath -localpath $LocalPath -remotepath $RemotePath -Mode Remote -Mirror -Remove -WinSCPSession $session

# Close the session object.
Remove-WinSCPSession -WinSCPSession $session
