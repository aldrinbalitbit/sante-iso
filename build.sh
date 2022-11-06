#!/bin/bash -e
banner () {
	echo "Sante ISO Build"
	sleep 5
}

thank_you () {
	echo "Thanks for building Sante ISO!"
}

configure_cmd () {
	./configure --prefix=/usr \
		     --host=x86_64-sante-gnu \
		     --build=x86_64-pc-linux-gnu \
		     --sbindir=/usr/bin\
		     --libexecdir=/usr/lib \
		     --includedir=/usr/include
		     $@
}

make_cmd () {
	make -j$(nproc)
	make -j$(nproc) $1 DESTDIR=/rootfs
}

# Build dependencies
sudo apt-get update -qqy
sudo apt-get install gcc g++ make

# Create rootfs directory
mkdir rootfs

# Create root file system directories and merge /usr
cd rootfs
mkdir -p {boot,home,mnt,opt,srv,etc,var/tmp,tmp,run,dev,sys,proc,root,usr/{bin,lib,share,src,local/{bin,lib}}}
ln -sf usr/bin bin
ln -sf usr/bin sbin
ln -sf usr/lib lib
ln -sf usr/lib lib64
ln -sf sbin usr/bin
ln -sf lib64 usr/lib
ln -sf sbin usr/local/bin
ln -sf lib64 usr/local/lib
cd ..

# Source build for rootfs
# GNU C Library
wget -qO- https://ftp.gnu.org/gnu/glibc/glibc-2.36.tar.gz | tar -xzpf -
cd glibc-2.36
configure_cmd CFLAGS="-w -g -O2"
make_cmd install
cd ..
