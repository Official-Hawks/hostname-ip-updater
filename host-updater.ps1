$oldip = type $env:APPDATA\ipconfig-Gateway.txt

ipconfig | findstr "Gateway" > $env:APPDATA\ipconfig-result.txt
Get-Content $env:APPDATA\ipconfig-result.txt | findstr "192.168.43" > $env:APPDATA\ipconfig-convert.txt
Get-Content $env:APPDATA\ipconfig-convert.txt | Select-String -Pattern '[192.168.43]+\.[0-9]+[0-9]' | % { $_.Matches } | % { $_.Value } > $env:APPDATA\ipconfig-Gateway.txt

$newip = type $env:APPDATA\ipconfig-Gateway.txt

copy $env:windir\System32\drivers\etc\hosts $env:APPDATA\hosts.backup
copy $env:APPDATA\hosts.backup $env:APPDATA\hosts.txt

$hosts = Get-Content "$env:APPDATA\hosts.txt"

$containsPH1 = $hosts | %{$_ -match "ph-1"}
if ($containsPH1 -contains $true) {

        (Get-ChildItem "$env:APPDATA\hosts.txt" -recurse).FullName |
    	    Foreach-Object {
	        (Get-Content $_ -Raw).
	    	Replace($oldip, $newip) |
    	    Set-Content $_
	    }

    } else {
    Add-Content $env:APPDATA\hosts.txt "`n$newip ph-1"
    }
copy $env:APPDATA\hosts.txt $env:windir\System32\drivers\etc\hosts