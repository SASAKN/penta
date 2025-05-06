global start
extern long_mode_start

; Text Section
section .text
bits 32
start:
    ; Set up the stack pointer
    mov esp, stack_top

    ; Check compatibility
    call check_bootloader
    call check_compatibility_cpuid
    ; call check_compatibility_long_mode

    ; Set up for long mode
    call set_up_page_tables
    call set_up_cr_registers
    call enable_long_mode
    call enable_paging

    ; Set up the GDT
    lgdt [gdt64.pointer]

    ; Jump to long mode
    jmp gdt64.code_segment:long_mode_start

    hlt ; halt the CPU


; Set up the page tables for long mode
set_up_page_tables:
    mov eax, page_table_l3
    or eax, 0b11 ; present and writable
    mov [page_table_l4], eax

    mov eax, page_table_l2
    or eax, 0b11
    mov [page_table_l3], eax

    mov ecx, 0        ; ループカウンタ
.loop:
    mov eax, ecx
    shl eax, 21   ; eax = ecx * 2MB（物理アドレス）
    or eax, 0b10000011  ; 2MBページ + Present + RW
    mov [page_table_l2 + ecx * 8], eax
    inc ecx
    cmp ecx, 512
    jne .loop


; Set up the CR3, CR4 registers
set_up_cr_registers:
    ; Set up CR3 register
    mov eax, page_table_l4
    mov cr3, eax

    ; Set up CR4 register
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

; Enable long mode
enable_long_mode:
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

; Enable paging
enable_paging:
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret


; Check whether the CPU is compatible for long mode(x86_64) or not
check_compatibility_long_mode:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .error ; Not compatible for long mode

    mov eax, 0x80000001
    cpuid
    test eax, 1 << 29 ; Check if long mode is supported
    jz .error

    ret
.error:
    mov al, "E" ; Set the error code
    jmp error


; Check whether the CPU is compatible for CPUID or not
check_compatibility_cpuid:
    pushfd ; Save flags
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax
    popfd
    pushfd
    pop eax
    push ecx
    popfd
    cmp eax, ecx
    je .error ; Not compatible for CPUID
    ret
.error:
    mov al, "E" ; Set the error code
    jmp error


; Check whether the bootloader is multiboot-compliant or not
check_bootloader:
    cmp eax, 0x36d76289 ; Check the magic number
    jne .error
    ret
.error:
    mov al, "E" ; Set error code
    jmp error

error:
	; print "ERR: X" where X is the error code
	mov dword [0xb8000], 0x4f524f45
	mov dword [0xb8004], 0x4f3a4f52
	mov dword [0xb8008], 0x4f204f20
	mov byte  [0xb800a], al
	hlt

; BSS Section
section .bss
align 4096
page_table_l4:
    resb 4096
page_table_l3:
    resb 4096
page_table_l2:
    resb 4096
stack_bottom:
    resb 16384
stack_top:

; RODATA Section
section .rodata
gdt64:
    dq 0 ; null entry
.code_segment: equ $ - gdt64
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53) ; code segment
.pointer:
    dw $ - gdt64 - 1 ; size
    dq gdt64 ; address


