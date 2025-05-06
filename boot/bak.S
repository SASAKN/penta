.section .multiboot2_header
.align 8
    .long 0xe85250d6       # magic
    .long 0                # architecture (0 = i386)
    .long header_end - header_start  # header length
    .long -(0xe85250d6 + 0 + (header_end - header_start)) # checksum
header_start:
    # optional tags (none for now)
header_end:


.section .bss
    .skip 16384
stack_top:

.section .text
    .global _start
    .type _start, @function
    _start:
        mov $stack_top, %rsp # initialize stack pointer
        push $0
        popf
        push %rax
        push %rbx
        call cstart # call C function
    1:
        hlt
        jmp 1b
