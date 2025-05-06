global long_mode_start
extern kernel_main

section .text
bits 64
long_mode_start:
    ; Disable Segmentation
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Call the kernel main function
    call kernel_main

    ; Halt the CPU
    hlt