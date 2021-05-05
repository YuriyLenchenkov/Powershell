get-mailbox -OrganizationalUnit "ou=OU1,ou=OU2,dc=domain,dc=ru" -resultsize unlimited



Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;
get-mailbox -OrganizationalUnit "ou=ou1,dc=domain,dc=ru" -resultsize unlimited |
Get-MailboxStatistics | Select DisplayName, @{name=”TotalItemSize”;expression={[math]::Round((($_.TotalItemSize.Value.ToString()).Split(“(“)[1].Split(” “)[0].Replace(“,”,””)/1GB),2)}} -ErrorAction SilentlyContinue | Export-Csv -Encoding UTF8 -Path C:\temp\krsk_users1.csv
