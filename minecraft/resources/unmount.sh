#!/bin/sh
set +e

# check if its a mountpoint
echo "Checking if mounted ${mountpoint}"
mountpoint "${mountpoint}"
result=$?
set -e

if [ $result = 0 ];
then
    # attempt unmount
    echo "Attempting unmount of ${mountpoint}"
    umount "${mountpoint}" 
fi

# finally if all has worked 
# lets clean up fstab
# remove any unwanted entries
cat /etc/fstab | \
    grep -v "${mountpoint}" | \
    grep -v "${linux_device}" > /tmp/${volume_id}

cp /etc/fstab /etc/fstab.backup
cp /tmp/${volume_id} /etc/fstab
chown root:root /etc/fstab
chmod 644 /etc/fstab
