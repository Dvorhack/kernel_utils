#!/usr/bin/env bash

function usage {
    echo "Usage: ./run.sh <linux kernel> <initramfs> [gdb]"
    exit 1
}

if [ -z "$1" ]
then
    usage
fi

if [ -z "$2" ]
then
    usage
fi

share_folder="/tmp/qmemu-share/"
mkdir -p "$share_folder"
echo "Trying to mount $share_folder"

if [[ "$3" =~ "gdb" ]]
then
echo "Starting with gdb"
echo "connect with 'gdb -ex \"target remote :1234\"'"

qemu-system-x86_64 -no-reboot \
    -m 256M\
    -kernel $1 \
    -initrd $2  \
    -cpu kvm64,+smep,+smap \
    -append "console=ttyS0 oops=panic panic=1 kpti=1 nokaslr quiet" \
    -monitor /dev/null \
    -serial mon:stdio \
    -virtfs local,path=$share_folder,mount_tag=host0,security_model=passthrough,id=foobar \
    -nographic -s -S
else
qemu-system-x86_64 -no-reboot \
    -m 256M\
    -kernel $1 \
    -initrd $2  \
    -cpu kvm64,+smep,+smap \
    -append "console=ttyS0 oops=panic panic=1 kpti=1 nokaslr quiet" \
    -monitor /dev/null \
    -serial mon:stdio \
    -virtfs local,path=$share_folder,mount_tag=host0,security_model=passthrough,id=foobar \
    -nographic
fi