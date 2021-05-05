#cls
$age = (Get-Date).AddDays(-730)
$path="some_path"

$folders=Get-ChildItem $path -Directory
$FoldersLastAccess=@()
foreach ($folder in $folders)
      {
      #$FoldersLastAccess+= New-Object PsObject -Property @{FullName=$folder.FullName;LastAccessTime=(Get-ChildItem $folder.FullName -File -Recurse | Where-Object {$_.LastAccessTime -lt $age} |Sort LastAccessTime| select -last 1).LastAccessTime}
      $FoldersLastAccess+= New-Object PsObject -Property @{FullName=$folder.FullName;LastAccessTime=(Get-ChildItem $folder.FullName -File -Recurse |Sort LastAccessTime| select -last 1).LastAccessTime}
      }
$FoldersLastAccess | Sort LastAccessTime
#$FoldersLastAccess | Export-Csv -NoTypeInformation -Encoding utf8 -delimiter ";" d:\FoldersLastAccess.csv


