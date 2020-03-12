Param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    $sciezka = (Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 5} | Select-Object DeviceID -ExpandProperty DeviceID)
)


$global:i=0
if (Test-Path -Path "$sciezka"){
    get-childitem `
    -Path $sciezka -Recurse -File -Exclude "player.zip" | `
    get-filehash -Algorithm MD5 | `
    Format-Table -Autosize -property `
    @{Name="Lp";Expression={$global:i.Tostring() + ".";$global:i++}}, `
    @{Name="Algorytm"; Expression = {$_.algorithm}}, hash, `
    @{Name="Plik"; Expression = {$_.Path -replace '(^.*)\\(.*.mp\d$)','$2'}} # | Out-Printer ; 
}
else {
    write-error "W NAPEDZIE BRAKUJE PLYTY, BADZ WSKAZANY FOLDER - $sciezka - NIE JEST PRAWIDLOWY."
}


$liczbaPlikow = Get-ChildItem $sciezka -Recurse | Measure-Object -property Length | select-object -ExpandProperty Count #zlicza pliki
$sumaPlikow = [Math]::Round((Get-ChildItem -Path $sciezka -Recurse | Measure-Object -property Length -Sum).Sum / 1MB, 2)

write-host "Na plycie / w folderze jest:" $liczbaPlikow "pliki / plikow o sumarycznym rozmiarze:" $sumaPlikow "MB"
