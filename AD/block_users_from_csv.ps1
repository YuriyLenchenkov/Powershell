#________________________________
#Tested with Powershell version 7
#________________________________
Import-Module ActiveDirectory
$log_path = "C:\ansible\logs\userblock.log"

$blockusers = Import-Csv -path "c:\ansible\blockusers.csv"
ForEach ($blockuser in $blockusers) {
		$fn = $blockuser.FirstName
		$sn = $blockuser.LastName
		if (Get-ADUser -Filter "givenname -eq '$fn' -and surname -eq '$sn'") {
			$sam = (Get-ADUser -Filter "givenname -eq '$fn' -and surname -eq '$sn'").samaccountname
			disable-adaccount -identity $sam
			move-adobject -identity ((get-aduser $sam).distinguishedname) -TargetPath "OU=disabled users,dc=tech,dc=local"
        Write-Output "User $($blockuser.FirstName) $($blockuser.LastName) from $($blockuser.CRQ_TAS) disabled, $(get-date -Format "f")"`
             | out-file -FilePath $log_path -Append
        }
    
        else {
        Write-Output "User $($blockuser.FirstName) $($blockuser.LastName) from $($blockuser.CRQ_TAS) not exists, $(get-date -Format "f")"`
             | out-file -FilePath $log_path -Append
        }
}
