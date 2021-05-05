$Users2Move = Get-ADUser -Filter * -Properties * | where-Object {$_.description -like "*ннп*" -and $_.DistinguishedName -like "*курск*" -and $_.enabled -eq $false}
foreach ($User2Move in $Users2Move)
                {
                Move-ADObject -identity ($User2Move).ObjectGUID -TargetPath "OU=some_ou1,OU=some_ou2,DC=some_domain,DC=ru"
                #Get-ADUser -Identity ($User2Move).ObjectGUID -properties *
                }
