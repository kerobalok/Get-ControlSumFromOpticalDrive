# Get-ControlSumFromOpticalDrive
Powershell script generating MD5 control sum (hashes) from files on optical drive.

# What it does?

The script automatically search for an optical drive in the system and recursively scan it for files. From finded files it will generate MD5 control sum (hash) and list all of them in the table format.
Files are displayed only by their names, without theirs full path.

At the end of its work, script will generate summary containing information which localisation was scanned (by default it's optical drive, but this can be changed by `-sciezka` parameter), how many files it contains, and overall size. 

# How to use it
This script can be run from PowerShell command line by using its name.

```powershell
.\Get-ControlSumFromOpticalDrive.ps1
```

## Parameters
Script has only one parameter, which is not required to run.

* `-sciezka` 

This parameter change behaviour of the script by forcing to scan for files path given by user instead searching for files in optical drive. 

```powershell
.\Get-ControlSumFromOpticalDrive.ps1 -sciezka "c:\exampleDirectory"
```
## Hidden features

Script can print its output to default system printer instead of console. To use this feature simply remove hashtag (`#`) in the line that looks like below. It is placed before `| Out-Printer`
```powershell
@{Name="Plik"; Expression = {$_.Path -replace '(^.*)\\(.+$)','$2'}} # | Out-Printer ;
```

# Example output
Below is the example of result. 

Script find optical drive in the system under letter `f:\` and scan it for files.

Table headers and summary are in Polish language. 
```powershell
Lp  Algorytm Hash                             Plik
--  -------- ----                             ----
1.  MD5      493BEA15925BDFEF65D0BC766B7F7E82 blank.vp6
2.  MD5      D9789F5A25F43D853ED0B720DD456EC3 DragTut_en.vp6
3.  MD5      ACA97CCC160516DA7E76F61AC0331F34 DriftTut_en.vp6
.
.
43. MD5      B691660F5F2535761E70A4D877BFA460 RunGame.exe
44. MD5      AF60560F93DF54BC2A41BDEF6B13958D speed2.exe

W napedzie / sciezce -F:- jest: 44 pliki / plikow o sumarycznym rozmiarze: 660.6 MB
```