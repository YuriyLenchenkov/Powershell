$Vmhosts = @("pc1","pc2","pc3")
$Report = @()
    foreach ($Vmhost in $Vmhosts)
    {
    $Adapters = (Get-VM -ComputerName $VMhost -Name *| Where-Object {$_.State -eq 'Running'}).networkadapters | select VMName, Name, SwitchName, IovUsage, PortMirroringMode
  
    $Report += ($Adapters)
   # Write-Output $VMhost, $Adapters    
    }
   # Write-Output $VMhost, $Report
    
    $Report | Export-csv -Path C:\temp\lenchenkov\sr-iov.csv -Encoding UTF8


#Get-VMNetworkAdapter -VMName pc1 | fl *
