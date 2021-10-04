#Для работы скрипта требуется модуль Powershell WinSCP

# Import WinSCP Module if needed
Import-Module WinSCP

# Create Credential Object
$username = "some_user"                                                                                              
$password = ConvertTo-SecureString "some_password" -AsPlainText -Force                                                 
$credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $password 

#Set Target Hostname
$Hostname = "some_host"           

#Paths
$LocalPath = "\\some_server\share"
$RemotePath = "/dir1/dir2/"


# Create new WinSCP session using captured credentials.
$sessionOption = New-WinSCPSessionOption -HostName $Hostname -PortNumber 22 -Credential $credential -GiveUpSecurityAndAcceptAnySshHostKey #-GiveUpSecurityAndAcceptAnyTlsHostCertificate
$session = New-WinSCPSession -SessionOption $sessionOption

# Upload a file to the directory.
sync-winscppath -localpath $LocalPath -remotepath $RemotePath -Mode Local -Mirror -Remove -WinSCPSession $session

# Close the session object.
Remove-WinSCPSession -WinSCPSession $session
