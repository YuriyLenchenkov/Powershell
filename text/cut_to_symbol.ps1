$a = "some_user@email.ru"
($a -replace '@(.+?)+', '')#.split(".")[0]
$b = "some_user1@email.ru"
write-host ($b.Substring(0, $b.LastIndexOf('@')))
