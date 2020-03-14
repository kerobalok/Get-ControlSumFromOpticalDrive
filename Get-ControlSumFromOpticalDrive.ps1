[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [ValidateScript({
        if (Test-Path -Path $_){
            $true
        }
        else {
            throw "Folder $_ nie istnieje"
        }
    })]
    $sciezka = (Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 5} | Select-Object DeviceID -ExpandProperty DeviceID)
)


$script:i=0

# nie zmieniać obslugi bledow na try catch poniewaz wymaga on wygenerowania bledu przerywajacego, ktory nie wystepuje w przypadku Test-Path
if (Test-Path -Path "$sciezka"){
    get-childitem `
    -Path $sciezka -Recurse -File -Exclude "player.zip" | `
    get-filehash -Algorithm MD5 | `
    Format-Table -Autosize -property `
    @{Name="Lp";Expression={$script:i.Tostring() + ".";$script:i++}}, `
    @{Name="Algorytm"; Expression = {$_.algorithm}}, hash, `
    @{Name="Plik"; Expression = {$_.Path -replace '(^.*)\\(.*.mp\d$)','$2'}} # | Out-Printer ; 
}
else {
    Write-Error "W NAPEDZIE BRAKUJE PLYTY, BADZ WSKAZANY FOLDER - $sciezka - NIE JEST PRAWIDLOWY."
}


$liczbaPlikow = Get-ChildItem $sciezka -Recurse | Measure-Object -property Length | select-object -ExpandProperty Count #zlicza pliki
$sumaPlikow = [Math]::Round((Get-ChildItem -Path $sciezka -Recurse | Measure-Object -property Length -Sum).Sum / 1MB, 2)

Write-Host "Na plycie / w folderze jest:" $liczbaPlikow "pliki / plikow o sumarycznym rozmiarze:" $sumaPlikow "MB"
