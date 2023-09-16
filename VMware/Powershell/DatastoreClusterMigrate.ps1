# Description: Migrates all VM storage in one datastore cluster to a different datastore cluster.
#
# Notes: Typically any VMs that have special requirements simply fail with an error and it continues on to the next.
# I have not had seen it cause an issue although you may want to throttle the task creation with a "wait" command in the loop.
#


# Specify the source and destination datastore cluster names
$sourceDatastoreClusterName = "ClusterA"
$destinationDatastoreClusterName = "ClusterB"

# Get the source and destination datastore cluster objects
$sourceDatastoreCluster = Get-DatastoreCluster -Name $sourceDatastoreClusterName
$destinationDatastoreCluster = Get-DatastoreCluster -Name $destinationDatastoreClusterName

# Get all VMs in the source datastore cluster
$sourceDatastoreClusterVMs = Get-VM -Datastore $sourceDatastoreCluster

# Move each VM to the destination datastore cluster
foreach ($vm in $sourceDatastoreClusterVMs) {
    Write-Host "Moving VM $($vm.Name) from $sourceDatastoreClusterName to $destinationDatastoreClusterName"
    Move-VM -VM $vm -Datastore $destinationDatastoreCluster -RunAsync
    Write-Host "----------"
}
