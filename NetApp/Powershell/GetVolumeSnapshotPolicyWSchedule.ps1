# Description: Prints a nice report of NetApp OnTap volumes, their snapshot policy, and it's schedule.


# Get the list of volumes
$volumes = Get-NcVol

# Loop through each volume and output the Snapshot Attributes
foreach ($volume in $volumes) {
    $snapshotAttributes = $volume.VolumeSnapshotAttributes

    # Output specific attributes
    Write-Host "Volume: $($volume.Name)"
    Write-Host "SnapshotPolicy: $($snapshotAttributes.SnapshotPolicy)"
    Get-NcSnapshotPolicy -Name $($snapshotAttributes.SnapshotPolicy)
    Write-Host "--"
}
