#!/bin/bash

container="/mnt/m2/veracrypt"
mount_point="/mnt/veracrypt2"

if sudo veracrypt --text --list 2>/dev/null | grep -Fq "$container"; then

    echo "VeraCrypt container is already mounted. Dismounting..."

    if sudo veracrypt --text --non-interactive --dismount "$container"; then
        echo "VeraCrypt container unmounted successfully."
    else
        echo "Failed to unmount the VeraCrypt container."
        exit 1
    fi

else

    read -s -p "Enter the password for the VeraCrypt container: " password
    echo

    if sudo veracrypt \
        --text \
        --non-interactive \
        --mount "$container" "$mount_point" \
        -p "$password"
    then
        echo "VeraCrypt container mounted successfully at $mount_point."
    else
        echo "Failed to mount the VeraCrypt container."
        exit 1
    fi

    unset password
fi
