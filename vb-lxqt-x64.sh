#!/bin/bash
DESKTOP="lxqt"
echo "========================="
echo "| ${DESKTOP} VOID x86_64    |"
echo " ------------------------"
CURRENT=https://mirror.fit.cvut.cz/voidlinux/current
MUTILIB=https://mirror.fit.cvut.cz/voidlinux/current/multilib
NONFREE=https://mirror.fit.cvut.cz/voidlinux/current/nonfree
FILENAME="vb-${DESKTOP}"
DATE=$(date +%Y%m%d)
KERNEL=$(uname -r)
BUILDDIR="$(pwd)/build"

retry=0

until [ -f ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso ];do
    ((retry++))
    if [[ $retry -gt 2 ]];then
        break
    fi

    sudo ./mklive.sh \
        -a x86_64 \
        -r "${CURRENT}" \
        -r "${MULTILIB}" \
        -p "$(grep '^[^#].' ${DESKTOP}-x64.packages)" \
        -T "vb ${DESKTOP}" \
        -o ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso
done

if [ ! -f ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso ];then
    retries=${1}
    until [[ $retries -gt 2 ]];do
        echo "Retrying build ${retries}" 
        ((retries++))
        bash ${0} ${retries}

    done
    if [[ ! -f ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso ]];then    
        echo "Error: ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso : does not exist! Aborting!"
        echo "ERR=1" > error-status.txt
        exit 1
    fi
fi

sha256sum ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso >> sha256sums.txt

if [ ! -f sha256sums.txt ];then
    echo "Missing checksum file, aborting!"
    echo "ERR=1" > error-status.txt
    exit 1
fi

if [ ! -d "${BUILDDIR}" ];then
    mkdir ${BUILDDIR}
fi

mv ${FILENAME}-x86_64-${KERNEL}-${DATE}.iso build
