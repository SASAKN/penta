	.file	"serial.c"
	.text
	.globl	outb
	.type	outb, @function
outb:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %edx
	movl	%esi, %eax
	movw	%dx, -4(%rbp)
	movb	%al, -8(%rbp)
	movzbl	-8(%rbp), %eax
	movzwl	-4(%rbp), %edx
/APP
# 6 "/Users/kenta/penta-os/kernel/serial.c" 1
	outb %al, %dx
# 0 "" 2
/NO_APP
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	outb, .-outb
	.globl	inb
	.type	inb, @function
inb:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	movl	%eax, %edx
/APP
# 12 "/Users/kenta/penta-os/kernel/serial.c" 1
	inb %dx, %al
# 0 "" 2
/NO_APP
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	inb, .-inb
	.globl	serial_init
	.type	serial_init, @function
serial_init:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, %esi
	movl	$1017, %edi
	call	outb
	movl	$128, %esi
	movl	$1019, %edi
	call	outb
	movl	$1, %esi
	movl	$1016, %edi
	call	outb
	movl	$0, %esi
	movl	$1017, %edi
	call	outb
	movl	$3, %esi
	movl	$1019, %edi
	call	outb
	movl	$199, %esi
	movl	$1018, %edi
	call	outb
	movl	$11, %esi
	movl	$1020, %edi
	call	outb
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	serial_init, .-serial_init
	.globl	read_ebx
	.type	read_ebx, @function
read_ebx:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
/APP
# 30 "/Users/kenta/penta-os/kernel/serial.c" 1
	mov %ebx, %eax
# 0 "" 2
/NO_APP
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	read_ebx, .-read_ebx
	.globl	serial_ready
	.type	serial_ready, @function
serial_ready:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$1021, %edi
	call	inb
	movzbl	%al, %eax
	andl	$32, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	serial_ready, .-serial_ready
	.globl	serial_putc
	.type	serial_putc, @function
serial_putc:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$8, %rsp
	movl	%edi, %eax
	movb	%al, -4(%rbp)
	nop
.L10:
	movl	$0, %eax
	call	serial_ready
	testl	%eax, %eax
	je	.L10
	movzbl	-4(%rbp), %eax
	movzbl	%al, %eax
	movl	%eax, %esi
	movl	$1016, %edi
	call	outb
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	serial_putc, .-serial_putc
	.globl	serial_puts
	.type	serial_puts, @function
serial_puts:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$8, %rsp
	movq	%rdi, -8(%rbp)
	jmp	.L12
.L15:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L16
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %edi
	call	serial_putc
	addq	$1, -8(%rbp)
.L12:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L15
	jmp	.L17
.L16:
	nop
.L17:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	serial_puts, .-serial_puts
	.globl	serial_inputc
	.type	serial_inputc, @function
serial_inputc:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	nop
.L19:
	movl	$1021, %edi
	call	inb
	movzbl	%al, %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L19
	movl	$1016, %edi
	call	inb
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	serial_inputc, .-serial_inputc
	.globl	serial_inputs
	.type	serial_inputs, @function
serial_inputs:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	$0, -8(%rbp)
	jmp	.L22
.L24:
	movl	$0, %eax
	call	serial_inputc
	movb	%al, -9(%rbp)
	movsbl	-9(%rbp), %eax
	movl	%eax, %edi
	call	serial_putc
	cmpb	$13, -9(%rbp)
	je	.L23
	cmpb	$10, -9(%rbp)
	je	.L23
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movzbl	-9(%rbp), %eax
	movb	%al, (%rdx)
	addq	$1, -8(%rbp)
.L22:
	movq	-32(%rbp), %rax
	subq	$1, %rax
	cmpq	%rax, -8(%rbp)
	jb	.L24
.L23:
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	serial_inputs, .-serial_inputs
	.ident	"GCC: (GNU) 14.2.0"
