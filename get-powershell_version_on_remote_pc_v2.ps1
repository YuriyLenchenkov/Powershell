﻿#$pcs = @("pc1","pc2")
$pcs = Get-Content -Path C:\files\information_IT\inventory\kursk-servers.txt

    foreach ($pc in $pcs)
    {
    $psv = Invoke-Command -Computername $pc -ScriptBlock {$psversiontable.PSVersion.Major}
    #Write-host $pc $(Invoke-Command -Computername $pc -ScriptBlock {$psversiontable.PSVersion.Major}) | Export-Csv -Path  C:\files\information_IT\inventory\server_kursk_powershell_version.csv
    #Write-host $pc $(Invoke-Command -Computername $pc -ScriptBlock {$psversiontable.PSVersion.Major}) 6>> C:\files\information_IT\inventory\server_kursk_powershell_version.csv
    
    Write-Output $($pc+" "+$psv) | Out-File -Append -FilePath C:\files\information_IT\inventory\posh_on_srv.txt
    }
