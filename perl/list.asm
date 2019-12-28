	.file	"list.c"
	.text
	.p2align 4,,15
.globl next_node
	.type	next_node, @function
next_node:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	popl	%ebp
	movl	(%eax), %eax
	ret
	.size	next_node, .-next_node
	.p2align 4,,15
.globl first_node
	.type	first_node, @function
first_node:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	popl	%ebp
	movl	4(%eax), %eax
	ret
	.size	first_node, .-first_node
	.p2align 4,,15
.globl remove_node
	.type	remove_node, @function
remove_node:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	pushl	%ebx
	movl	4(%eax), %edx
	testl	%edx, %edx
	je	.L6
	movl	(%eax), %ecx
	movl	%ecx, (%edx)
	movl	16(%eax), %ecx
	movl	(%eax), %ebx
.L7:
	testl	%ebx, %ebx
	je	.L8
	movl	%edx, 4(%ebx)
.L9:
	subl	$1, 12(%ecx)
	movl	$0, 4(%eax)
	movl	$0, (%eax)
	popl	%ebx
	popl	%ebp
	ret
	.p2align 4,,7
	.p2align 3
.L8:
	movl	%edx, 8(%ecx)
	jmp	.L9
	.p2align 4,,7
	.p2align 3
.L6:
	movl	(%eax), %ebx
	xorl	%edx, %edx
	movl	16(%eax), %ecx
	movl	%ebx, 4(%ecx)
	jmp	.L7
	.size	remove_node, .-remove_node
	.p2align 4,,15
.globl swap_nodes
	.type	swap_nodes, @function
swap_nodes:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	pushl	%ebx
	movl	12(%edx), %ecx
	movl	12(%eax), %ebx
	movl	%ebx, 12(%edx)
	movl	%ecx, 12(%eax)
	popl	%ebx
	popl	%ebp
	ret
	.size	swap_nodes, .-swap_nodes
	.p2align 4,,15
.globl dobitsort
	.type	dobitsort, @function
dobitsort:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$60, %esp
	movl	8(%ebp), %edi
	movl	16(%ebp), %ebx
	.p2align 4,,7
	.p2align 3
.L32:
	movl	%edi, %edx
	movl	12(%ebp), %eax
	movl	8(%edx), %esi
	movl	%edi, -44(%ebp)
	movl	%ebx, %edi
	movl	8(%eax), %ecx
	andl	%esi, %edi
	movl	%edi, -28(%ebp)
	jne	.L33
.L34:
	movl	8(%eax), %esi
	movl	%ebx, %ecx
	movl	(%edx), %edx
	andl	%esi, %ecx
	testl	%edx, %edx
	movl	%ecx, -28(%ebp)
	je	.L23
.L39:
	cmpl	%eax, %edx
	je	.L23
	movl	%esi, %ecx
	movl	8(%edx), %esi
	movl	%ebx, %edi
	andl	%esi, %edi
	movl	%edi, -28(%ebp)
	je	.L34
.L33:
	movl	-44(%ebp), %edi
	jmp	.L30
	.p2align 4,,7
	.p2align 3
.L36:
	movl	8(%eax), %ecx
.L30:
	testl	%ebx, %ecx
	je	.L35
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jne	.L36
	movl	4(%edx), %eax
	testl	%eax, %eax
	je	.L37
.L19:
	sarl	%ebx
	je	.L28
	cmpl	%eax, %edi
	.p2align 4,,3
	je	.L38
	cmpl	(%eax), %edi
	.p2align 4,,5
	je	.L26
	movl	%eax, 4(%esp)
	movl	%edi, (%esp)
	movl	%eax, -32(%ebp)
	movl	%ebx, 8(%esp)
	call	dobitsort
	movl	-32(%ebp), %eax
	movl	(%eax), %edi
.L26:
	testl	%edi, %edi
	je	.L28
	cmpl	%edi, 12(%ebp)
	je	.L28
	cmpl	12(%ebp), %eax
	jne	.L32
.L28:
	addl	$60, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	.p2align 4,,1
	ret
	.p2align 4,,7
	.p2align 3
.L35:
	movl	%ecx, 8(%edx)
	movl	(%edx), %edx
	movl	%edi, -44(%ebp)
	movl	%esi, 8(%eax)
	testl	%edx, %edx
	jne	.L39
	.p2align 4,,7
	.p2align 3
.L23:
	movl	-28(%ebp), %edx
	movl	-44(%ebp), %edi
	testl	%edx, %edx
	je	.L19
	movl	4(%eax), %eax
	jmp	.L19
	.p2align 4,,7
	.p2align 3
.L38:
	movl	(%edi), %edi
	jmp	.L26
	.p2align 4,,7
	.p2align 3
.L37:
	cmpl	%edx, 12(%ebp)
	.p2align 4,,5
	je	.L28
	movl	%edx, %edi
	.p2align 4,,5
	jmp	.L32
	.size	dobitsort, .-dobitsort
	.p2align 4,,15
.globl bitsort
	.type	bitsort, @function
bitsort:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
	movl	12(%ebp), %eax
	movl	8(%ebp), %edx
	testl	%eax, %eax
	jne	.L42
	movl	4(%edx), %esi
	testl	%esi, %esi
	je	.L43
	movl	%esi, %ecx
	.p2align 4,,7
	.p2align 3
.L44:
	movl	8(%ecx), %ebx
	movl	(%ecx), %ecx
	cmpl	%ebx, %eax
	cmovl	%ebx, %eax
	testl	%ecx, %ecx
	jne	.L44
	testl	%eax, %eax
	je	.L43
.L42:
	xorl	%ecx, %ecx
	.p2align 4,,7
	.p2align 3
.L46:
	addl	$1, %ecx
	sarl	%eax
	jne	.L46
	movl	$1, %eax
	sall	%cl, %eax
	testl	%eax, %eax
	jne	.L53
	addl	$16, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.p2align 4,,7
	.p2align 3
.L53:
	movl	4(%edx), %esi
.L48:
	movl	%eax, 8(%esp)
	movl	8(%edx), %eax
	movl	%esi, (%esp)
	movl	%eax, 4(%esp)
	call	dobitsort
	addl	$16, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
.L43:
	movl	$1, %eax
	jmp	.L48
	.size	bitsort, .-bitsort
	.p2align 4,,15
.globl bitsort2
	.type	bitsort2, @function
bitsort2:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
	movl	12(%ebp), %eax
	movl	8(%ebp), %edx
	testl	%eax, %eax
	jne	.L56
	movl	4(%edx), %esi
	testl	%esi, %esi
	je	.L57
	movl	%esi, %ecx
	.p2align 4,,7
	.p2align 3
.L58:
	movl	8(%ecx), %ebx
	movl	(%ecx), %ecx
	cmpl	%ebx, %eax
	cmovl	%ebx, %eax
	testl	%ecx, %ecx
	jne	.L58
	testl	%eax, %eax
	je	.L57
.L56:
	xorl	%ecx, %ecx
	.p2align 4,,7
	.p2align 3
.L60:
	addl	$1, %ecx
	sarl	%eax
	jne	.L60
	movl	$1, %eax
	sall	%cl, %eax
	testl	%eax, %eax
	jne	.L67
	addl	$16, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.p2align 4,,7
	.p2align 3
.L67:
	movl	4(%edx), %esi
.L62:
	movl	%eax, 8(%esp)
	movl	8(%edx), %eax
	movl	%esi, (%esp)
	movl	%eax, 4(%esp)
	call	dobitsort
	addl	$16, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
.L57:
	movl	$1, %eax
	jmp	.L62
	.size	bitsort2, .-bitsort2
	.p2align 4,,15
.globl dobitsort2
	.type	dobitsort2, @function
dobitsort2:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$44, %esp
	movl	12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	16(%ebp), %edi
	movl	%edx, -32(%ebp)
	movl	%edx, %ebx
	movl	%eax, -28(%ebp)
	movl	8(%edx), %eax
	movl	-28(%ebp), %esi
	jmp	.L79
	.p2align 4,,7
	.p2align 3
.L69:
	movl	8(%ebx), %edx
	movl	%edi, %ecx
	movl	%edi, %eax
	sarl	%eax
	andl	%edx, %ecx
.L74:
	movl	(%esi), %esi
	cmpl	%ebx, %esi
	je	.L78
.L91:
	testl	%esi, %esi
	je	.L78
	movl	%edx, %eax
.L79:
	movl	8(%esi), %edx
	movl	%edi, %ecx
	andl	%edx, %ecx
	je	.L69
	testl	%eax, %edi
	je	.L70
	.p2align 4,,7
	.p2align 3
.L90:
	cmpl	%ebx, %esi
	je	.L73
	movl	4(%ebx), %ebx
	movl	8(%ebx), %eax
	testl	%eax, %edi
	jne	.L90
.L70:
	cmpl	%ebx, %esi
	je	.L73
	movl	%eax, 8(%esi)
	movl	(%esi), %esi
	movl	%edi, %eax
	sarl	%eax
	movl	%edx, 8(%ebx)
	cmpl	%ebx, %esi
	jne	.L91
.L78:
	testl	%ecx, %ecx
	jne	.L92
.L80:
	testl	%eax, %eax
	je	.L83
	cmpl	-28(%ebp), %ebx
	.p2align 4,,5
	je	.L93
	movl	-28(%ebp), %edx
	cmpl	(%ebx), %edx
	.p2align 4,,3
	je	.L82
	movl	%eax, 8(%esp)
	movl	%edx, (%esp)
	movl	%ebx, 4(%esp)
	movl	%eax, -36(%ebp)
	call	dobitsort
	movl	(%ebx), %edx
	movl	-36(%ebp), %eax
	movl	%edx, -28(%ebp)
.L82:
	movl	-28(%ebp), %ecx
	testl	%ecx, %ecx
	je	.L83
	movl	-28(%ebp), %edx
	cmpl	%edx, -32(%ebp)
	jne	.L94
.L83:
	addl	$44, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,7
	.p2align 3
.L73:
	sarl	%edi
	jne	.L75
	movl	%esi, %ebx
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	jmp	.L74
	.p2align 4,,7
	.p2align 3
.L92:
	movl	4(%ebx), %ebx
	jmp	.L80
.L94:
	cmpl	-32(%ebp), %ebx
	je	.L83
	movl	%eax, 16(%ebp)
	movl	-32(%ebp), %eax
	movl	%edx, 8(%ebp)
	movl	%eax, 12(%ebp)
.L89:
	addl	$44, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	jmp	dobitsort
.L93:
	movl	(%ebx), %edx
	movl	%edx, -28(%ebp)
	jmp	.L82
.L75:
	movl	4(%esi), %eax
	testl	%eax, %eax
	je	.L76
	movl	%edi, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	dobitsort
.L76:
	cmpl	-32(%ebp), %esi
	je	.L83
	movl	-32(%ebp), %edx
	movl	%edi, 16(%ebp)
	movl	%esi, 8(%ebp)
	movl	%edx, 12(%ebp)
	jmp	.L89
	.size	dobitsort2, .-dobitsort2
	.p2align 4,,15
.globl destroy_node
	.type	destroy_node, @function
destroy_node:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	leave
	jmp	free
	.size	destroy_node, .-destroy_node
	.p2align 4,,15
.globl delete_node
	.type	delete_node, @function
delete_node:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$4, %esp
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	testl	%edx, %edx
	je	.L98
	movl	(%eax), %ecx
	movl	%ecx, (%edx)
	movl	16(%eax), %ecx
	movl	(%eax), %ebx
.L99:
	testl	%ebx, %ebx
	je	.L100
	movl	%edx, 4(%ebx)
.L101:
	subl	$1, 12(%ecx)
	movl	$0, 4(%eax)
	movl	$0, (%eax)
	movl	%eax, 8(%ebp)
	addl	$4, %esp
	popl	%ebx
	popl	%ebp
	jmp	free
	.p2align 4,,7
	.p2align 3
.L100:
	movl	%edx, 8(%ecx)
	jmp	.L101
	.p2align 4,,7
	.p2align 3
.L98:
	movl	(%eax), %ebx
	xorl	%edx, %edx
	movl	16(%eax), %ecx
	movl	%ebx, 4(%ecx)
	jmp	.L99
	.size	delete_node, .-delete_node
	.p2align 4,,15
.globl new_node
	.type	new_node, @function
new_node:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$20, (%esp)
	movl	%ebx, -12(%ebp)
	movl	8(%ebp), %ebx
	movl	%esi, -8(%ebp)
	movl	16(%ebp), %esi
	movl	%edi, -4(%ebp)
	movl	20(%ebp), %edi
	call	malloc
	movl	12(%ebp), %edx
	addl	$1, 12(%ebx)
	testl	%esi, %esi
	movl	%ebx, 16(%eax)
	movl	%edx, 12(%eax)
	movl	%esi, 4(%eax)
	je	.L104
	movl	%eax, (%esi)
	cmpl	%esi, 8(%ebx)
	je	.L109
.L104:
	testl	%edi, %edi
	movl	%edi, (%eax)
	je	.L105
	movl	%eax, 4(%edi)
.L105:
	movl	4(%ebx), %edi
	testl	%edi, %edi
	je	.L110
.L106:
	movl	8(%ebx), %esi
	testl	%esi, %esi
	je	.L111
.L107:
	movl	24(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	-12(%ebp), %ebx
	movl	-8(%ebp), %esi
	movl	-4(%ebp), %edi
	movl	%ebp, %esp
	popl	%ebp
	ret
	.p2align 4,,7
	.p2align 3
.L111:
	movl	%eax, 8(%ebx)
	jmp	.L107
	.p2align 4,,7
	.p2align 3
.L110:
	movl	%eax, 4(%ebx)
	jmp	.L106
	.p2align 4,,7
	.p2align 3
.L109:
	movl	%eax, 8(%ebx)
	.p2align 4,,5
	jmp	.L104
	.size	new_node, .-new_node
	.p2align 4,,15
.globl append_new_node
	.type	append_new_node, @function
append_new_node:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	16(%ebp), %edx
	movl	$0, 12(%esp)
	movl	%edx, 16(%esp)
	movl	8(%eax), %edx
	movl	%eax, (%esp)
	movl	%edx, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	call	new_node
	leave
	ret
	.size	append_new_node, .-append_new_node
	.p2align 4,,15
.globl ensure_count_nodes
	.type	ensure_count_nodes, @function
ensure_count_nodes:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	movl	8(%ebp), %edi
	movl	12(%ebp), %eax
	cmpl	%eax, 12(%edi)
	jl	.L121
	addl	$28, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,7
	.p2align 3
.L121:
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	%edi, (%esp)
	call	append_new_node
	movl	12(%ebp), %esi
	subl	12(%edi), %esi
	testl	%esi, %esi
	movl	%eax, %ebx
	jg	.L120
	jmp	.L116
	.p2align 4,,7
	.p2align 3
.L122:
	movl	%eax, %ebx
.L120:
	movl	$20, (%esp)
	subl	$1, %esi
	call	malloc
	testl	%esi, %esi
	movl	%eax, (%ebx)
	movl	%ebx, 4(%eax)
	movl	%edi, 16(%eax)
	movl	$0, 8(%eax)
	movl	$0, 12(%eax)
	jg	.L122
	movl	%eax, %ebx
.L116:
	movl	12(%ebp), %eax
	movl	%ebx, 8(%edi)
	movl	$0, (%ebx)
	movl	%eax, 12(%edi)
	addl	$28, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	ensure_count_nodes, .-ensure_count_nodes
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC0:
	.string	"Dump list. expecting %d elements.\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"%d "
.LC2:
	.string	"\n\n"
	.text
	.p2align 4,,15
.globl Dump
	.type	Dump, @function
Dump:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$20, %esp
	movl	8(%ebp), %ebx
	movl	12(%ebx), %eax
	movl	$.LC0, 4(%esp)
	movl	$1, (%esp)
	movl	%eax, 8(%esp)
	call	__printf_chk
	movl	4(%ebx), %ebx
	testl	%ebx, %ebx
	je	.L124
	.p2align 4,,7
	.p2align 3
.L127:
	movl	8(%ebx), %eax
	movl	$.LC1, 4(%esp)
	movl	$1, (%esp)
	movl	%eax, 8(%esp)
	call	__printf_chk
	movl	(%ebx), %ebx
	testl	%ebx, %ebx
	jne	.L127
.L124:
	movl	$.LC2, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	addl	$20, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	Dump, .-Dump
	.section	.rodata.str1.1
.LC3:
	.string	"%d \n"
	.text
	.p2align 4,,15
.globl set_count_nodes
	.type	set_count_nodes, @function
set_count_nodes:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$44, %esp
	movl	8(%ebp), %ebx
	movl	12(%ebp), %esi
	movl	12(%ebx), %edi
	cmpl	%esi, %edi
	je	.L136
	jl	.L139
	subl	%esi, %edi
	movl	8(%ebx), %eax
	cmpl	$1, %edi
	jle	.L132
	.p2align 4,,7
	.p2align 3
.L137:
	movl	4(%eax), %eax
	subl	$1, %edi
	movl	(%eax), %edx
	movl	%edx, (%esp)
	movl	%eax, -28(%ebp)
	call	free
	cmpl	$1, %edi
	movl	-28(%ebp), %eax
	jg	.L137
.L132:
	movl	4(%eax), %edi
	testl	%edi, %edi
	je	.L134
	movl	(%edi), %eax
	movl	%eax, (%esp)
	call	free
	movl	$77, 8(%esp)
	movl	$.LC3, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	$0, (%edi)
.L135:
	movl	%edi, 8(%ebx)
	movl	%esi, 12(%ebx)
.L136:
	addl	$44, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,7
	.p2align 3
.L139:
	movl	$64, 8(%esp)
	movl	$.LC3, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	%esi, 12(%ebp)
	movl	%ebx, 8(%ebp)
	addl	$44, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	jmp	ensure_count_nodes
	.p2align 4,,7
	.p2align 3
.L134:
	movl	%eax, (%esp)
	call	free
	movl	$81, 8(%esp)
	movl	$.LC3, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	$0, 4(%ebx)
	jmp	.L135
	.size	set_count_nodes, .-set_count_nodes
	.section	.rodata.str1.1
.LC4:
	.string	"Destroy list\n"
.LC5:
	.string	"Destroying Node with key %d\n"
.LC6:
	.string	"Destroyed\n"
	.text
	.p2align 4,,15
.globl destroy_list
	.type	destroy_list, @function
destroy_list:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	movl	8(%ebp), %edi
	movl	$.LC4, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	4(%edi), %ebx
	testl	%ebx, %ebx
	je	.L141
	.p2align 4,,7
	.p2align 3
.L144:
	movl	(%ebx), %esi
	movl	8(%ebx), %eax
	movl	$.LC5, 4(%esp)
	movl	$1, (%esp)
	movl	%eax, 8(%esp)
	call	__printf_chk
	movl	%ebx, (%esp)
	movl	%esi, %ebx
	call	free
	testl	%esi, %esi
	jne	.L144
.L141:
	movl	%edi, (%esp)
	call	free
	movl	$.LC6, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	addl	$28, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	destroy_list, .-destroy_list
	.section	.rodata.str1.1
.LC7:
	.string	"Create list\n"
	.text
	.p2align 4,,15
.globl new_list
	.type	new_list, @function
new_list:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$20, %esp
	movl	$16, (%esp)
	call	malloc
	movl	%eax, %ebx
	movl	$0, 12(%eax)
	movl	$0, 4(%eax)
	movl	$0, 8(%eax)
	movl	$.LC7, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	%ebx, %eax
	addl	$20, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	new_list, .-new_list
	.ident	"GCC: (Gentoo 4.4.5 p1.2, pie-0.4.5) 4.4.5"
	.section	.note.GNU-stack,"",@progbits
