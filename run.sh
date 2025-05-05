#!/bin/bash

# Directory
script_dir="$(dirname "$(readlink -f "$0")")"

# Open qemu
qemu-system-x86_64 -cdrom "${script_dir}/os.iso" -m 4G -drive if=pflash,format=raw,file="${script_dir}/OVMF_CODE.fd" -nographic