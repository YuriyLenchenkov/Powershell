#________________________________
#Tested with Powershell version 7
#________________________________

#Генератор пароля
function Get-RandomCharacters {
    $characters1 = "ABCDEFGHKLMNOPRSTUVWXYZ"
    $random1 = 0..1 | ForEach-Object { Get-Random -Maximum $characters1.Length }
    $characters2 = "1234567890"
    $random2 = 0..1 | ForEach-Object { Get-Random -Maximum $characters2.Length }
    $characters3 = "abcdefghiklmnoprstuvwxyz"
    $random3 = 0..1 | ForEach-Object { Get-Random -Maximum $characters3.Length }
    $characters4 = "!`"$%&/()=?}][{@#*+"
    $random4 = 0..1 | ForEach-Object { Get-Random -Maximum $characters4.Length }
    $private:ofs=""
    $charset_final = Get-Random -inputobject ($characters1[$random1]+$characters2[$random2]+$characters3[$random3]+$characters4[$random4]) -Count 8
    return [String]$charset_final
}
#Отправка почты
function Send-mail ($et, $pass) {
    $EmailTo = $et
    $EmailFrom = "sender@email"
    $Subject = "subject_text"
    $Body = @"
<!DOCTYPE html>
<html>
<body>
<font size="5">
Добрый день.<br>
</font>
</body>
</html>
"@
    $SMTPServer = "server_ip" 
    #$smtpUsername = "smtp_user"
    #$smtpPassword = ConvertTo-SecureString "some_password" -AsPlainText -Force
    #$credentials = new-object Management.Automation.PSCredential($smtpUsername, $smtpPassword);
    Send-MailMessage -Subject $Subject -To $EmailTo -Credential (([System.Management.Automation.PSCredential]::Empty)) <#-Credential $credentials#> -SmtpServer $SMTPServer -Port 25 -From $EmailFrom `
      -Body $Body -BodyAsHtml -Encoding utf8 -Attachments "c:\file1","c:\file2" -ErrorAction Stop
}

#Импортируем модуль AD
Import-Module ActiveDirectory
$log_path = "c:\ansible\logs\usercreationlog.log"
#Работа с учтеками юзеров
$newusers = import-csv -path "c:\ansible\newusers.csv"
ForEach ($newuser in $newusers) {
    if (![String]::IsNullOrWhiteSpace($newuser.End_Date)) {
            
            #создаем нового юзера с ограничением срока действия, добавляем группы, отправляем письмо на почту
            $password = Get-RandomCharacters
            try {
                New-ADUser -Name "$($newuser.FirstName) $($newuser.LastName)" -GivenName $newuser.FirstName`
            -Surname $newuser.LastName -SamAccountName ($newuser.Login.ToLower())`
            -UserPrincipalName "$($newuser.Login.ToLower())@tech.local" -Description $newuser.CRQ_TAS`
            -DisplayName "$($newuser.FirstName) $($newuser.LastName)" -Path "OU=RMIS,DC=tech,DC=local"`
            -AccountPassword ($password | ConvertTo-SecureString -AsPlainText -Force) -Enabled $true -ErrorAction Stop
            Set-ADAccountExpiration -Identity $newuser.Login -DateTime (Get-Date $newuser.End_Date).AddDays(1)
            Set-ADUser -Identity $newuser.Login -PasswordNeverExpires $true -Replace @{info = "Ansible created"}
            Add-ADGroupMember -Identity $newuser.Group -Members $newuser.Login
                try {
                Send-mail $newuser.Email $password
                }
                catch {
                Write-Output "Error sending email User $($newuser.Login) from $($newuser.CRQ_TAS), $(get-date -Format "f")"`
             | out-file -FilePath $log_path -Append
                }
            #Пишем в лог, что пользователь создан
            Write-Output "User $($newuser.Login) from $($newuser.CRQ_TAS) created with expiration date, $(get-date -Format "f")"`
             | out-file -FilePath $log_path -Append
            }
            catch {
                #Меняем дату истечения учетки и номер TAS\CRQ
                Set-ADAccountExpiration -Identity $newuser.Login.ToLower() -DateTime (Get-Date $newuser.End_Date).AddDays(1)
                #пишем в лог, юзер существует, дата и TAS\CRQ изменены.
                Write-Output "User $($newuser.Login) from $($newuser.CRQ_TAS) already exists, expiration date updated, $(get-date -Format "f")"`
             | out-file -FilePath $log_path -Append
            }
         
    }
    Else {
            #создаем нового юзера с бессрочным доступом, добавляем группы, отправляем письмо на почту
            $password = Get-RandomCharacters
            try {
                New-ADUser -Name "$($newuser.FirstName) $($newuser.LastName)" -GivenName $newuser.FirstName`
            -Surname $newuser.LastName -SamAccountName $newuser.Login.ToLower()`
            -UserPrincipalName "$($newuser.Login.ToLower())@tech.local" -Description $newuser.CRQ_TAS`
            -DisplayName "$($newuser.FirstName) $($newuser.LastName)" -Path "OU=RMIS,DC=tech,DC=local"`
            -AccountPassword ($password | ConvertTo-SecureString -AsPlainText -Force) -Enabled $true -ErrorAction stop
            Set-ADUser -Identity $newuser.Login -PasswordNeverExpires $true -Replace @{info = "Ansible created"}
            Add-ADGroupMember -Identity $newuser.Group -Members $newuser.Login
                try {
                Send-mail $newuser.Email $password
                }
                catch {
                Write-Output "Error sending email User $($newuser.Login) from $($newuser.CRQ_TAS), $(get-date -Format "f")"`
             | out-file -FilePath $log_path -Append
                }
            #Пишем в лог, что пользователь создан
            Write-Output "User $($newuser.Login) from $($newuser.CRQ_TAS), no expiration date reqired, $(get-date -Format "f")"`
             | out-file -FilePath $log_path -Append
                }
            catch {
                Write-Output "User $($newuser.Login) from $($newuser.CRQ_TAS) already exists, no expiration date reqired, $(get-date -Format "f")"`
                | out-file -FilePath $log_path -Append
                }
            }
        
        
    }
