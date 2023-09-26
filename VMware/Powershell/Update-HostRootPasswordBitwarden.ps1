$env:BW_CLIENTID = ""
$env:BW_CLIENTSECRET = ""
$bitwardenPasswordGenerationCommand = ""
$bitwardenLoginCommand = ".\bw.exe login --apikey ; bw unlock"

# JSON payload
$jsonPayload = @{
    folderid  = ""     
    name     = $bitwardenEntryName
    type     = "login"
    notes    = ""
    login    = @{
        password = $generatedPassword
    }
} | ConvertTo-Json

# Define the Bitwarden CLI command to create/modify an item
$bitwardenEntryUpdateCommand = "bw.exe create item --json '$jsonPayload'"

# Connect to the vCenter Server
Connect-VIServer -Server ""

# Login to Bitwarden
Write-Host "Logging into Bitwarden"
Invoke-Expression $bitwardenLoginCommand

# Loop through each datacenter
$datacenters = Get-Datacenter
foreach($datacenter in $datacenters){

    # Loop through each cluster
    $clusters = Get-Cluster -Location $datacenter
    foreach ($cluster in $clusters) {

        # Generate password
        $generatedPassword = Invoke-Expression $bitwardenPasswordGenerationCommand

        # Update the Bitwarden entry for the cluster
        $bitwardenEntryName = $datacenter.Name + " - " + $cluster.Name + " - local root"
        Write-Host "Updated Bitwarden: $bitwardenEntryName"
        #Invoke-Expression $bitwardenEntryUpdateCommand
        
        # Loop through each host in the cluster
        $vmhosts = Get-VMHost -Location $cluster
        foreach ($vmhost in $vmhosts) {
            # Change the root account password on the host to the generated password
            Write-Host "Updated local root password for $vmhost" -ForegroundColor Green
            #Set-VMHostAccount -UserAccount root -Password $generatedPassword -Host $vmhost -Confirm:$false
        }
    Write-Host "---------------------"
    }
}

$generatedPassword = "password"

# Disconnect from the vCenter Server
Disconnect-VIServer -Confirm:$false
