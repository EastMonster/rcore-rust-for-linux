#!/bin/bash
WORK_DIR="${HOME}/cw/rcore-rust-for-linux"
BOOT_PATH="../linux/build/arch/arm64/boot"
BUSYBOX_PATH="../busybox-1.36.1"
INITRAMFS="initramfs.cpio.gz"

repack() {
    echo Repacking...
    cd ${BUSYBOX_PATH}/_install
    find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../${INITRAMFS}
    cd ${WORK_DIR}

    echo Repack Done!
}

if [[ -n "$1" && "$1" = "-r" ]] || [ ! -f "${BUSYBOX_PATH}/${INITRAMFS}" ]; then
    repack
fi

timestamp1=$(stat -c %Y ${BUSYBOX_PATH}/${INITRAMFS})
timestamp2=0
if [ -f "${BOOT_PATH}/${INITRAMFS}" ]; then
    timestamp2=$(stat -c %Y ${BOOT_PATH}/${INITRAMFS})
fi

echo $timestamp1
echo $timestamp2

if [ "$timestamp1" -gt "$timestamp2" ]; then
    cp -f ${BUSYBOX_PATH}/${INITRAMFS} $BOOT_PATH
fi

qemu-system-aarch64 \
    -kernel ${BOOT_PATH}/Image \
    -M virt \
    -cpu cortex-a72 \
    -smp 8 \
    -m 1G \
    -initrd ${BOOT_PATH}/${INITRAMFS} \
    -append "init=/init console=ttyAMA0"