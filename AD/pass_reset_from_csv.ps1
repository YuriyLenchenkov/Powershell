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
    $EmailFrom = "sender@email.com"
    $Subject = "subject"
    $Body = @"
<!DOCTYPE html>
<html>
<body>
<font size="5">
Добрый день.<br>
Логин:  $($passreset.Login.ToLower())  (для доступа по RPD $($passreset.Login.ToLower()))<br>
Пароль: <b>$password</b><br>
<b>Письмо отправлено атоматически. В случае необходимости, для ответа используйте адрес</b><br>
</font>
</body>
</html>
"@
    $SMTPServer = "server" 
    #$smtpUsername = "smtp_user"
    #$smtpPassword = ConvertTo-SecureString "pass" -AsPlainText -Force
    #$credentials = new-object Management.Automation.PSCredential($smtpUsername, $smtpPassword);
Send-MailMessage -Subject $Subject -To $EmailTo -Credential (([System.Management.Automation.PSCredential]::Empty)) <#-Credential $credentials#> -SmtpServer $SMTPServer -Port 25 -From $EmailFrom -Body $Body -BodyAsHtml -Encoding utf8 -ErrorAction Stop
}
#Импортируем модуль AD
Import-Module ActiveDirectory

#Работа с учтеками юзеров
$passresets = import-csv -path "c:\ansible\passreset.csv"
$log_path = "c:\ansible\logs\passreset.log"
ForEach ($passreset in $passresets) {
   		$password = Get-RandomCharacters
        try {
			Set-AdAccountpassword -Identity $passreset.Login -Reset -NewPassword ($password | ConvertTo-SecureString -AsPlainText -Force) -ErrorAction stop
			Write-Output "Password resetted $($passreset.Login), $(get-date -Format "f")" | out-file -FilePath $log_path -Append
		}
		catch {
        Write-Output "Password has not been resetted $($passreset.Login), $(get-date -Format "f")" | out-file -FilePath $log_path -Append
		}
		try {
            Send-mail $passreset.Email $password
        }
		catch {
            Write-Output "Error sending email User $($passreset.Login), $(get-date -Format "f")" | out-file -FilePath $log_path -Append
		}
		
	}
