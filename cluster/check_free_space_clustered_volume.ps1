(((Get-ClusterSharedVolume -Cluster cluster_name -name "disk_name").sharedvolumeinfo).partition).freespace / 1gb
