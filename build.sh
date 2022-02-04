#!/bin/bash

echo "Cloning dependencies"

git clone --depth=1 https://github.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-r416183b1 clang
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 android-4.9-64
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 androideabi-4.9-32
git clone --depth=1 https://github.com/NaissAA/AnyKernel3.git AnyKernel

echo "Done"

export ARCH=arm64
export KBUILD_BUILD_USER=ruka
export KBUILD_BUILD_HOST=nasif
ZIPNAME="Ruka_KERNEL-RMX1821-$(date '+%Y%m%d-%H%M').zip"
PATH="${PWD}/clang/bin:${PATH}:${PWD}/androideabi-4.9-32/bin:${PATH}:${PWD}/android-4.9-64/bin:${PATH}" \

# Compile plox
function compile() {

make -j$(nproc) O=out ARCH=arm64 RMX1821_defconfig
make -j$(nproc) O=out \
                ARCH=arm64 \
                CC=clang \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                CROSS_COMPILE=aarch64-linux-android- \
                CROSS_COMPILE_ARM32=arm-linux-androideabi-
}

# Zipping
function zipping() {

cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 $ZIPNAME *
}

# zip upload
function upload() {

#curl --upload-file $ZIPNAME https://transfer.sh/
curl -sL https://git.io/file-transfer | sh
./transfer wet $ZIPNAME
}

compile
zipping
upload
