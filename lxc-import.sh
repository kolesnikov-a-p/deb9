#!/bin/bash

CONTAINER=$1
WORKPATCH=`pwd`

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "Этот сценарий должен выполняться от имени root"
    exit 1
fi

echo "Import container $CONTAINER"
cd /var/lib/lxc/
tar --numeric-owner -xzf $WORKPATCH/$CONTAINER .
echo "Done"
exit 1
