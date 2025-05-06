#!/bin/bash

# Directory
script_dir="$(dirname "$(readlink -f "$0")")"

# Build Directory
build_dir="${script_dir}/build"

# Image file path
image_file="${script_dir}/os.iso"

# Kernel file path
kernel_file="${script_dir}/build/iso/boot/kernel.elf"

# GRUB Config file path
grub_cfg_file="${script_dir}/build/iso/boot/grub/grub.cfg"

# Compile the assembly code
# x86_64-elf-gcc -ffreestanding -m64 -c "${script_dir}/boot/boot.S" -o "${build_dir}/boot.o" -I "${script_dir}/include"

# compile the nasm code
nasm -f elf64 "${script_dir}/boot/boot.asm" -o "${build_dir}/boot.o"
nasm -f elf64 "${script_dir}/boot/boot64.asm" -o "${build_dir}/boot64.o"
nasm -f elf64 "${script_dir}/boot/header.asm" -o "${build_dir}/header.o"

# Compile the kernel code
x86_64-elf-gcc -ffreestanding -m64 -c "${script_dir}/kernel/main.c" -o "${build_dir}/kernel.o" -I "${script_dir}/include"

# Link the kernel and boot code
x86_64-elf-ld -n -o ${build_dir}/kernel.elf -T ${script_dir}/kernel/kernel.ld ${build_dir}/header.o ${build_dir}/boot.o ${build_dir}/boot64.o ${build_dir}/kernel.o --oformat=elf64-x86-64

# Put the kernel in ISO folder
cp ${build_dir}/kernel.elf ${build_dir}/iso/boot/kernel.elf

# Create the ISO image
x86_64-elf-grub-mkrescue -o ${image_file} ${build_dir}/iso

echo "ISO image created at ${image_file}"