.section .multiboot2_header
.align 8
.long 0xe85250d6         # magic
.long 0                  # architecture
.long header_end - header_start  # header length
.long -(0xe85250d6 + 0 + (header_end - header_start)) # checksum
header_start:
    # 空（オプション無し）
header_end:

.section .bss
    .skip 16384
stack_top:

.section .text
    .global _start
    .type _start, @function
    _start:
        mov %rsp, stack_top
        call cstart
    1:
        hlt
        jmp 1b
