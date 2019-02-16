#!/bin/bash

VMACHINE=$1
WORKPATCH=`pwd`

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "Этот сценарий должен выполняться от имени root"
    exit 1
fi

echo "Export > container_$VMACHINE.tar.gz"
cd /var/lib/lxc/
tar --numeric-owner -czf $WORKPATCH/container_$VMACHINE.tar.gz ./$VMACHINE/
echo "Done"
exit 1
