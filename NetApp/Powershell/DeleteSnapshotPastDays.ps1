# Description: incredibly usefull to batch delete snapshots past X amount of days

# Set the target SVM and maximum snapshot age in days
$targetSVM = "svmfqdn"
$controller ="controllerfqdn"
$days = (get-date).adddays(-7) #replace with how many days you want to keep, keep the negative in there

Connect-NcController $controller -Vserver $targetSVM -ONTAPI


# Get the list of volumes on the target SVM
$volumes = Get-NcVol -Vserver $targetSVM

# Loop through each volume and remove old snapshots
foreach ($volume in $volumes) {

    # Get snapshots older than the specified age
    $oldSnapshots = Get-NcSnapshot -Volume $volume | Where-Object { $_.created -lt $days }

    # Remove the old snapshots
    foreach ($snapshot in $oldSnapshots) {
        Write-Host "Removing snapshot $($snapshot) on volume $($volume)"
        Remove-NcSnapshot  -Volume $volume -Snapshot $snapshot -Confirm:$false
        Write-Host "---------------------------------------------------"
    }
}
