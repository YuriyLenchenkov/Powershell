function Get-ComputerSite($ComputerName)
{
   $site = nltest /server:$ComputerName /dsgetsite 2>$null
   if($LASTEXITCODE -eq 0){ $site[0] }
}
 
 
 Get-ADComputer -Filter 'OperatingSystem -like "*server*"' -Property Name, OperatingSystem -ResultPageSize 1000| select Name, OperatingSystem, @{Name="ADSite";Expression={Get-ComputerSite -ComputerName $_.Name}} | Export-Csv C:\files\server_site_os.csv -NoTypeInformation


 #$Computer = Get-ADComputer -Filter 'OperatingSystem -like "*server*"' -Property Name,OperatingSystem | select Name, OperatingSystem, @{Name="ADSite";Expression={Get-ComputerSite -ComputerName $_.Name}}
 
 #$Computer = Get-ADComputer -Filter 'Name -eq "01-GW-001"' -Property Name,OperatingSystem | select Name, OperatingSystem, @{Name="ADSite";Expression={Get-ComputerSite -ComputerName $_.Name}}

 #$Computer | Export-Csv C:\files\server_site_os.csv -NoTypeInformation
