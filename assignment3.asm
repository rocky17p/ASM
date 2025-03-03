section .data
    arr dq 0000000000000008H, 0000000000000001H, 0000000000000009H, 0000000000000003H, 0000000000000007H
    arrlen db 05H
    msg db "Array: "
    msglen equ $-msg
    msg1 db "Greatest Number: "
    msg1len equ $-msg1
    newline db 10
    temp db 05H                 ; temp updated to 5 for 5 elements

section .bss
    num resb 16

%macro rw 3
    mov rax, %1
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

section .text
global _start
_start:
    ; Printing Array
    rw 1, msg, msglen
    rw 1, newline, 1

    mov rbp, arr
back1:
    mov rbx, [rbp]
    call hexToAscii
    rw 1, num, 16
    rw 1, newline, 1
    add rbp, 8
    dec byte[temp]
    jnz back1

    ; Greatest Number printer
    rw 1, msg1, msg1len

    mov rdi, arr
    mov rbx, [rdi]
    movzx rcx, byte[arrlen]

back:
    cmp [rdi], rbx
    jg b1
    jmp b2

b1: 
    mov rbx, [rdi]

b2: 
    add rdi, 8
    dec rcx
    jnz back

    call hexToAscii
    rw 1, num, 16
    exit

; Hex to ASCII procedure
hexToAscii:
    mov rcx, 16
    mov rdi, num

loop1:
    rol rbx, 4
    mov al, bl
    and al, 0Fh
    cmp al, 9
    jg a1
    add al, 30h
    jmp a2

a1: 
    add al, 37h

a2: 
    mov byte [rdi], al
    inc rdi
    dec rcx
    jnz loop1

    ret
