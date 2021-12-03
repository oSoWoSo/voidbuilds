#!/bin/bash
echo "============================="
echo "| RPI4 OPENBOX VOID AARCH64 |"
echo "-----------------------------"

CURRENT=https://mirror.fit.cvut.cz/voidlinux/current/aarch64
NONFREE=https://mirror.fit.cvut.cz/voidlinux/current/aarch64/nonfree

FILENAME="void-rpi4"
DATE=$(date +%Y%m%d)
BUILDDIR="$(pwd)/build"

retry=0
 Run command with set architechure, repos and package list
until [ -f ${FILENAME}-openbox-unofficial-${DATE}.img ];do

    ((retry++))
    if [[ $retry -eq 2 ]];then
        break
    fi
	echo "MKROOTFS"
	sudo ./mkrootfs.sh -o ${FILENAME}-ROOTFS-${DATE}.tar.xz aarch64
	
	echo "MKPLATFORMFS"

    sudo ./mkplatformfs.sh \
        -r "${CURRENT}" \
        -r "${NONFREE}" \
        -p "$(grep '^[^#].' rpi4-openbox-aarch64.packages)" \
        -o ${FILENAME}-PLATFORMFS-${DATE}.tar.xz rpi4 ${FILENAME}-ROOTFS-${DATE}.tar.xz
	echo "MKIMAGE"
    sudo ./mkimage.sh -o ${FILENAME}-openbox-unofficial-${DATE}.img ${FILENAME}-PLATFORMFS-${DATE}.tar.xz
    
done

 Make sure resulting ISO exists and sent error to webpage if not
if [ ! -f ${FILENAME}-openbox-unofficial-${DATE}.img ];then   
        echo "Error: ${FILENAME}-openbox-unofficial-${DATE}.img : does not exist! Aborting!"
        echo "ERR=1" > error-status.txt
        exit 1
fi

# Add iso file to checksum list
${FILENAME}-openbox-unofficial-${DATE}.img >> sha256sums.txt



# Check if checksum file exists, send error to webpage if not
if [ ! -f sha256sums.txt ];then
    echo "Missing checksum file, aborting!"
    echo "ERR=1" > error-status.txt
    exit 1
fi

# make sure build directory exists and create it if not
if [ ! -d "${BUILDDIR}" ];then
    mkdir ${BUILDDIR}
fi

# Move the iso file to the build directory
mv ${FILENAME}-openbox-unofficial-${DATE}.img build
