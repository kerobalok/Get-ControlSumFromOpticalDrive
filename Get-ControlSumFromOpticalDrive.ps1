[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
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

# nie zmieniac obslugi bledow na try catch poniewaz wymaga on wygenerowania bledu przerywajacego, ktory nie wystepuje w przypadku Test-Path
if (Test-Path -Path "$sciezka"){
    Get-Childitem `
    -Path $sciezka -Recurse -File -Exclude "player.zip" | `
    Get-Filehash -Algorithm MD5 | `
    Format-Table -Autosize -property `
    @{Name="Lp";Expression={$script:i.Tostring() + ".";$script:i++}}, `
    @{Name="Algorytm"; Expression = {$_.algorithm}}, hash, `
    @{Name="Plik"; Expression = {$_.Path -replace '(^.*)\\(.+$)','$2'}} # | Out-Printer ; 
    
    # podsumowanie
    $liczbaPlikow = Get-ChildItem $sciezka -Recurse | Measure-Object -property Length | select-object -ExpandProperty Count
    $sumaPlikow = [Math]::Round((Get-ChildItem -Path $sciezka -Recurse | Measure-Object -property Length -Sum).Sum / 1MB, 2)
    Write-Output "W napedzie / sciezce - $sciezka - jest: $liczbaPlikow pliki o rozmiarze: $sumaPlikow MB"
}
else {
    Write-Error -Message "W NAPEDZIE BRAKUJE PLYTY, BADZ WSKAZANY FOLDER - $sciezka - NIE JEST PRAWIDLOWY." -Category InvalidArgument
}