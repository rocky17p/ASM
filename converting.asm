section .data
	msg db"enter 2 digit number",10
	len equ $-msg
section .bss
	num resb 3
	hexa resb 1
	result resb 2
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
	;----------------
	func 1,1,msg,len
	func 0,0,num,3
	call ascii_to_hex
	mov bl,[hexa]
	call hex_to_ascii
	;-----------
	mov rax,60
	mov rdx,0
	syscall
	
	;-----------ascii to hex
ascii_to_hex:
	mov rsi,num
	mov rbx,0
	mov rcx,2
convert_loop:
	rol rbx,04h
	mov al,[rsi]
	cmp al,39h
	jbe next
	sub al,07h
next:
	sub al,30h
	add bx,ax
	inc rsi
	dec rcx
	jnz convert_loop
	mov [hexa],bl
	ret
;-------------------hex to ascii
hex_to_ascii:
	mov rdi,result
	mov rcx,2
convert:
	rol bl,04h
	mov dl,bl
	and dl,0Fh
	cmp dl,09h
	jbe nxt
	add dl,07h
nxt:
	add dl,30h
	mov [rdi],dl
	inc rdi
	dec rcx
	jnz convert
	
	func 1,1,result,2
	ret
	
	
