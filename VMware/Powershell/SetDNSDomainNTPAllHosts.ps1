# Description: loops through all hosts in connected vCenter and sets NTP, DNS, and DomainName for quick consistency across the board
#
# Note: at the bottom of the script is a way to export the info which can be good for before/after comparison
#


# Variables for domain name and primary and alternate DNS/NTP servers (i used domain controllers for DNS/NTP 2in1)
$domainname = "google.com"
$primary ="8.8.8.8"
$secondary = "8.8.4.4"
 
foreach ($esx in Get-VMHost) {
    Write-Host "Configuring DNS and Domain Name on $esx"
    Get-VMHostNetwork -VMHost $esx | Set-VMHostNetwork -DomainName $domainname -DNSAddress $primary , $secondary -Confirm:$false
    Write-Host "Configuring NTP Servers on $esx"
    Add-VMHostNTPServer -NtpServer $primary , $secondary -VMHost $esx -Confirm:$false
    Write-Host "Configuring NTP Client Policy on $esx"
    Get-VMHostService -VMHost $esx | Where-Object{$_.Key -eq "ntpd"} | Set-VMHostService -policy "on" -Confirm:$false
    Write-Host "Restarting NTP Client on $esx"
    Get-VMHostService -VMHost $esx | Where-Object{$_.Key -eq "ntpd"} | Restart-VMHostService -Confirm:$false
    Write-Host "--"
}

<#----------------- replace above "foreach" with below to export info to csv


foreach ($esx in Get-VMHost) {
    Get-VMHostNetwork -VMHost $esx | Select-Object -Property * | Export-Csv -Append "Get-VMHostNetwork.csv"
    Get-VMHostService -VMHost $esx | Where-Object{$_.Key -eq "ntpd"} | Select-Object -Property * | Export-Csv -Append "Get-VMHostServiceNTPD.csv"
}


#>
