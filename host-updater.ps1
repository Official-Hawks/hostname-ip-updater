#Set hostname
$chostname = 'ph-1'

#Copy hosts file to temp directory - backup and convert to txt file
copy $env:windir\System32\drivers\etc\hosts $env:APPDATA\hosts.backup
copy $env:APPDATA\hosts.backup $env:APPDATA\hosts.txt
#Content of hosts to var
$hostsfile = Get-Content $env:APPDATA\hosts.txt

#If old ip file exist set oldip, needed if things go weird.. possibly, still in testing to move to var only
$oldip = type $env:APPDATA\gw-ip.txt

#Change first 3 octects of ip to your need for /24 etc.
#Current gateway string "Default Gateway . . . . . . . . . : 192.168.43.*"
$GatewayString = ipconfig | Select-String  '[192.168]+\.43+\.[0-9]+[0-9]' | Select-String -allMatch "gateway"
#Clean string to just ip and save to file - update file for future old ip
$Gateway = $GatewayString | Select-String -Pattern '[192.168]+\.43+\.[0-9]+[0-9]' | % { $_.Matches } | % { $_.Value }; $Gateway > $env:APPDATA\gw-ip.txt
#$gateway = new ip

#Setting variables
#Look if hostname exist in hosts
$containsPH1 = $hostsfile | %{$_ -match $chostname}
#Look if old ip is in hosts
$Contains43 = $hostsfile | %{$_ -match '[192.168]+\.43+\.[0-9]+[0-9]'}

#if old ip exists - update it
if ($Contains43 -contains $true) {

    #if old ip is in hosts file set oldip var, just in case oldip is blank..
    $oldip = $hostsfile | Select-String -Pattern '[192.168]+\.43+\.[0-9]+[0-9]' | % { $_.Matches } | % { $_.Value };
   
    (gc $env:APPDATA\hosts.txt -raw) -replace ($oldip, $Gateway) | Set-Content $env:APPDATA\hosts.txt; 
}#end if

#if old ip does not exist, check and remove hostname if exists # $chostname is hostname
elseif ($containsPH1 -contains $true) {

(gc $env:APPDATA\hosts.txt) -NotMatch $chostname | Out-File $env:APPDATA\hosts.txt;

#Add new ip with hostname
Add-Content $env:APPDATA\hosts.txt "`n$gateway $chostname"
}#end elseif

#If none of above exists add new line and
else {echo 'new'; pause; Add-Content $env:APPDATA\hosts.txt "`n$gateway $chostname"; echo done; pause}

#Clean and copy modified hosts file back to system, the next line removes empty lines because overtime it can get messy, comment next line if you need empty lines..
(gc $env:APPDATA\hosts.txt) | ? {$_.trim()-ne "" } | Set-Content $env:APPDATA\hosts.txt
copy $env:APPDATA\hosts.txt $env:windir\System32\drivers\etc\hosts
exit