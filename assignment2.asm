section .data
    ipmsg db "Enter a string"
    ipmsglen equ $ -ipmsg
    opmsg db "The length of the string is: "
    opmsglen equ $ - opmsg
    newline db 10
    newlinelen equ $-newline

section .bss
    str1 resb 100
    result resb 50

section .text
    global _start

%macro rw 3
    mov rax, %1
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

_start:
    rw 1, ipmsg, ipmsglen
    rw 1,newline,newlinelen
    rw 0, str1, 100
    mov rbx, rax
    mov rcx, 16
    mov rdi, result

loop1:
    rol rbx, 04H
    mov al, bl
    AND al, 0FH
    cmp al, 09H
    jg b1
    add al,30H
    jmp b2

b1:
    add al, 37H

b2:
    mov byte[rdi], al
    inc rdi
    dec rcx
    jnz loop1

    rw 1, opmsg, opmsglen
    rw 1, result, 16
    rw 1,newline,newlinelen

    mov rax, 60
    mov rdi,0
    syscall
