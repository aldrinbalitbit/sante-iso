#!/bin/bash -e
banner () {
	echo "Sante ISO Build"
	sleep 5
}

thank_you () {
	echo "Thanks for building Sante ISO!"
}

configure_cmd () {
	mkdir build
	cd build
	../configure --prefix=/usr \
		     --target=x86_64-sante-gnu \
		     --build=x86_64-pc-linux-gnu \
		     --sbindir=/usr/bin\
		     --libexecdir=/usr/lib \
		     --includedir=/usr/include \
		     $@
	cd ..
}

make_cmd () {
	make -C build
	make -C build $@ DESTDIR=$HOME/sante-iso/rootfs
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
ln -sf usr/lib libexec
ln -sf sbin usr/bin
ln -sf lib64 usr/lib
ln -sf sbin usr/local/bin
ln -sf lib64 usr/local/lib
cd ..

# Source build for rootfs
# GNU C Library
sudo apt-get install bash binutils coreutils diffutils gawk gettext \
		     grep perl sed texinfo
wget -qO- https://ftp.gnu.org/gnu/glibc/glibc-2.36.tar.gz | tar -xzpf -
cd glibc-2.36
configure_cmd --enable-multi-arch \
	      --disable-werror \
	      CFLAGS="${CFLAGS}"
make_cmd install
cd ..
rm -rf glibc-2.36
