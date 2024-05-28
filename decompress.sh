#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo "Usage: ./compress.sh <initramfs>"
    exit 1
fi

mime=$(file -i -b "$1")

mkdir -p initramfs
cd initramfs

if [[ "$mime" =~ "application/gzip" ]]
then
    gzip -dc "../$1" | cpio -idm 
elif [[ "$mime" =~ "application/x-cpio" ]]
then
    cpio -idm < "../$1"
else
    echo "Unknown type of file $1"
fi