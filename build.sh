#!/bin/bash -e
banner () {
	echo "Sante ISO Build"
	sleep 5
}

thank_you () {
	echo "Thanks for building Sante ISO!"
}

# Build dependencies
sudo apt-get update -qqy
sudo apt-get install gcc g++ make

# Create rootfs directory
mkdir rootfs

# Create root file system directories and merge /usr
cd rootfs
mkdir -p {boot,home,mnt,opt,srv,etc,var,run,dev,sys,proc,root,usr/{bin,lib,share,src}}
ln -sf usr/bin bin
ln -sf usr/bin sbin
ln -sf usr/lib lib
ln -sf usr/lib lib64
ln -sf sbin usr/bin
ln -sf lib64 usr/lib
