	.file	"main.c"
	.text
	.section	.rodata
.LC0:
	.string	"Hello, World!\n"
	.text
	.globl	kernel_main
	.type	kernel_main, @function
kernel_main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, %eax
	call	serial_init
	movl	$.LC0, %edi
	call	serial_puts
.L2:
/APP
# 12 "/Users/kenta/penta-os/kernel/main.c" 1
	hlt
# 0 "" 2
/NO_APP
	jmp	.L2
	.cfi_endproc
.LFE0:
	.size	kernel_main, .-kernel_main
	.ident	"GCC: (GNU) 14.2.0"
