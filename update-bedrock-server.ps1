$sourcePath = 'bedrock-server'
$destinationPath = 'bedrock-server-backup\{0}' -f (Get-Date -Format "yyyyMMdd_HHmmss")
New-Item -ItemType Directory -Path $destinationPath
Write-Output "Cздание бекапа"
Copy-Item -Path "$sourcePath\worlds" -Destination $destinationPath -Recurse
Copy-Item -Path "$sourcePath\allowlist.json" -Destination $destinationPath
Copy-Item -Path "$sourcePath\permissions.json" -Destination $destinationPath
Copy-Item -Path "$sourcePath\server.properties" -Destination $destinationPath

Write-Output "Cздание бекапа завершено, удаление старой версии"
Remove-Item -Path $sourcePath -Recurse -Force

C:\CMD\curl-8.4.0_6-win64-mingw\bin\curl.exe --user-agent "Mozilla/5.0 (X11; CrOS x86_64 12871.102.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.141 Safari/537.36" https://www.minecraft.net/ru-ru/download/server/bedrock > version.txt
$fileContent = Get-Content -Path "version.txt" -Raw
$pattern = 'https://minecraft\.azureedge\.net/bin-win/bedrock-server-\d+\.\d+\.\d+\.\d+\.zip'
$matches = [regex]::Matches($fileContent, $pattern)
foreach ($match in $matches) {
    Write-Output $match.Value > version.txt
}
$versionFile = Get-Content -Path "version.txt" -First 1
Write-Output "Актуальная ссылка получена. Идет скачивание"
Invoke-WebRequest -Uri $versionFile -OutFile "bedrock-server.zip"
Write-Output "Получен архив, идет рспаковка"
Expand-Archive -Path 'bedrock-server.zip' -DestinationPath 'bedrock-server'
Remove-Item -Path 'bedrock-server.zip' -Force

Write-Output "Перенос бекапа на новую версию"
Copy-Item -Path $destinationPath\* -Destination $sourcePath -Recurse