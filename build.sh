#!/bin/bash

# Directory
script_dir="$(dirname "$(readlink -f "$0")")"

# Build Directory
build_dir="${script_dir}/build"

# ISO Image path
image_file="${script_dir}/os.iso"

# Kernel file path
kernel_file="${build_dir}/iso/boot/kernel.elf"

# GRUB Config file path
grub_cfg_file="${build_dir}/iso/boot/grub/grub.cfg"

# Create build directories if not exist
mkdir -p "${build_dir}/iso/boot/grub"

# Assemble boot files
nasm -f elf64 "${script_dir}/boot/boot.asm" -o "${build_dir}/boot.o"
nasm -f elf64 "${script_dir}/boot/boot64.asm" -o "${build_dir}/boot64.o"
nasm -f elf64 "${script_dir}/boot/header.asm" -o "${build_dir}/header.o"

# Compile all C source files in kernel directory into object files
kernel_objs=()
for cfile in "${script_dir}/kernel/"*.c; do
  ofile="${build_dir}/$(basename "${cfile%.c}.o")"
  x86_64-elf-gcc -ffreestanding -m64 -c "$cfile" -o "$ofile" -I "${script_dir}/include"
  kernel_objs+=("$ofile")
done

# Link the kernel and boot code
x86_64-elf-ld -n -o "${build_dir}/kernel.elf" \
  -T "${script_dir}/kernel/kernel.ld" \
  "${build_dir}/header.o" \
  "${build_dir}/boot.o" \
  "${build_dir}/boot64.o" \
  "${kernel_objs[@]}" \
  --oformat=elf64-x86-64

# Copy kernel to ISO folder
mkdir -p "${build_dir}/iso/boot"
cp "${build_dir}/kernel.elf" "$kernel_file"

# Create the ISO image
x86_64-elf-grub-mkrescue -o "${image_file}" "${build_dir}/iso"

echo "✅ ISO image created at ${image_file}"
