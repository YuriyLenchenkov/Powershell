cls
$patch="some_path"

$folders=Get-ChildItem $patch -Directory
#$folders
$FoldersLastAccess=@()
foreach ($folder in $folders)
      {
      
      $folder.FullName
      #Get-ChildItem $folder.FullName -File -Recurse | select -First 1 LastAccessTime
      #$files | ft Name, LastAccessTime
      #$LastAccess = 
      #$LastAccess = ($files | select -First 1 LastAccessTime).LastAccessTime
      #$LastAccess
      $FoldersLastAccess+= New-Object PsObject -Property @{Name=$folder.Name;FullName=$folder.FullName;LastAccessTime=(Get-ChildItem $folder.FullName -File -Recurse |Sort LastAccessTime| select -last 1).LastAccessTime}
      }
$FoldersLastAccess
$FoldersLastAccess | Export-Csv -NoTypeInformation -Encoding utf8 -delimiter ";" d:\FoldersLastAccess.csv
