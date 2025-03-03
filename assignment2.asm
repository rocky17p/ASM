section .data
    ipmsg db "Enter a string", 0xa
    ipmsglen equ $ - ipmsg
    opmsg db "The length of the string is: ", 0xa
    opmsglen equ $ - opmsg

section .bss
    str1 resw 100
    result resb 50

section .text
    global _start

%macro func 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

_start:
    func 1, 1, ipmsg, ipmsglen
    func 0, 0, str1, 100

    mov rbx, rax
    mov rcx, 16
    mov rbp, result

back:
    rol rbx, 04h
    mov al, bl
    AND al, 0Fh
    cmp al, 09h
    jbe add_30
    add al,07h
    jmp skip

add_30:
    add al, 30h

skip:
    mov [rbp], al
    inc rbp
    dec rcx
    jnz back

    func 1, 1, opmsg, opmsglen
    func 1, 1, result, 16

    mov rax, 60
    xor rdi, rdi
    syscall
