Param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    $sciezka = (Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 5} | Select-Object DeviceID -ExpandProperty DeviceID)
)


if (Test-Path -Path "$sciezka")
{
    write-host "Sciezka jest poprawna"
}
else {
    Write-Error -Message "Podana sciezka nie jest poprawna."
}


# if ((Get-Item $sciezka) -is [System.IO.DirectoryInfo]){
#     Write-Host "To jest folder"
# }
# else {
#     write-host "$siezka nie jest folderem."
# }


# try {
#     $sciezka = Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 5} | Select-Object DeviceID -ExpandProperty DeviceID
# }
# catch {
#     write-error "W komputerze nie znalazłem napędu optycznego"
# }


$i=0



try {
    get-childitem `
    -Path $sciezka -Recurse -File -Exclude "player.zip" | `
    get-filehash -Algorithm MD5 | `
    Format-Table -Autosize -property `
    @{Name="Lp";Expression={$global:i.Tostring() + ".";$global:i++}}, `
    @{Name="Algorytm"; Expression = {$_.algorithm}}, hash, `
    @{Name="Plik"; Expression = {$_.Path -replace '(^.*)\\(.*.mp\d$)','$2'}} # | Out-Printer ; 
}
catch {
    write-error "W NAPEDZIE BRAKUJE PLYTY, BADZ WSKAZANY FOLDER - $sciezka - NIE JEST PRAWIDLOWY."
}


$liczbaPlikow = Get-ChildItem $sciezka -Recurse | Measure-Object -property Length | select-object -ExpandProperty Count #zlicza pliki
$sumaPlikow = [Math]::Round((Get-ChildItem -Path $sciezka -Recurse | Measure-Object -property Length -Sum).Sum / 1MB, 2)

write-host "Na plycie jest:" $liczbaPlikow "pliki / plikow o sumarycznym rozmiarze:" $sumaPlikow "MB"

#zlicza rekursyjnie rozmiar plików i folderów, ale coś nie do końca jest to zgodne z tym co widać w eksploratorze
#Get-ChildItem d: -Recurse | Measure-Object -property Length -Sum | select-object -ExpandProperty Sum 
