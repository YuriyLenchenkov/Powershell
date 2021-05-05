Get-ADUser -Filter {msRTCSIP-PrimaryUserAddress -ne "$null"} –Properties "DisplayName", msRTCSIP-PrimaryUserAddress  -SearchBase "OU=some_ou область,DC=some_domain,DC=ru" | select DisplayName, msRTCSIP-PrimaryUserAddress  

Get-ADUser -Filter {msRTCSIP-PrimaryUserAddress -ne "$null"} –Properties "DisplayName", msRTCSIP-PrimaryUserAddress  -SearchBase "OU=some_ou область,DC=some_domain,DC=ru" | select DisplayName, msRTCSIP-PrimaryUserAddress | Export-Csv -Encoding UTF8 -Path  
