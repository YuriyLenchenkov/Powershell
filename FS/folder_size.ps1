Function Get-FolderSize

{

 BEGIN{$fso = New-Object -comobject Scripting.FileSystemObject}

 PROCESS{

    $path = $input.fullname

    $folder = $fso.GetFolder($path)

    $size = $folder.size

    [PSCustomObject]@{‘Name’ = $path;’Size’ = ($size / 1gb) } } }

    [math]::Round((gci C:\files -Directory -EA 0 | Get-FolderSize | Measure-Object -Property size -Sum).sum, 2) -replace ",", "."

    remove-Item Function:\Get-FolderSize
