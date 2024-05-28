#!/usr/bin/env bash

if [ ! -d "$1" ]
then
    echo "Usage: ./compress.sh <initramfs folder> [-g]"
    exit 1
fi

cd "$1"

if [ "$2" == "-g" ]
then
    find . -print0 \
    | cpio --null -o --format=newc \
    | gzip -9 > initramfs.cpio.gz
    mv ./initramfs.cpio.gz ../
else
    find . -print0 \
    | cpio --null -o --format=newc > initramfs.cpio
    mv ./initramfs.cpio ../
fi