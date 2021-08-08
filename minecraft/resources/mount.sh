#!/bin/sh
set -e

# check mount point available
mkdir -p "${mountpoint}"

if [ ! -z "$(ls -A '${mountpoint}')" ]; then
   echo "${mountpoint} is not empty"
   exit 1
fi

# Mount the device
mount -o discard,defaults ${linux_device} ${mountpoint}

# verify
mountpoint "${mountpoint}"

# finally if all has worked 
# lets add entry into fstab
# remove any old entries
cat /etc/fstab | \
    grep -v "${mountpoint}" | \
    grep -v "${linux_device}" > /tmp/${volume_id}

# add entry   
echo "${linux_device} ${mountpoint}  ${format} discard,nofail,defaults 0 0" \
    >> /tmp/${volume_id}

cp /etc/fstab /etc/fstab.backup
cp /tmp/${volume_id} /etc/fstab
chown root:root /etc/fstab
chmod 644 /etc/fstab