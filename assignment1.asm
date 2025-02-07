section .data
	msg db "helloworld",0xA
	len equ $-msg
section .bss
	var resb 85
section .text
	global _start
	%macro func 4
		mov rax,%1
		mov rdi,%2
		mov rsi,%3
		mov rdx,%4
		syscall
	%endmacro
_start:
	mov r8,5
	mov rsi,var
loop_start:
	func 0,0,rsi,17
	func 1,1,rsi,17
	add rsi,17
	dec r8
	jnz loop_start
	
	
	mov rax,60
	mov rdi,0
	syscall
	
	
