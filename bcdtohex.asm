%macro m 3
    mov rax, %1
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

section .data
    msg1 db "ENTER THE NUMBER: "
    l1 equ $ - msg1
    menu db 10, 13, "ENTER 1 FOR BCD TO HEX"
         db 10, 13, "ENTER 2 FOR HEX TO BCD"
         db 10, 13, "ENTER 3 TO EXIT"
    l equ $ - menu

section .bss
    input resb 10
    choice resb 2
    sum resq 1
    sum1 resq 1
    result1 resb 16
    multi resq 2

section .text
    global _start

_start:
lp1:
    m 1, menu, l
    m 0, choice, 2
    cmp byte [choice], '1'
    je bcdtohex
    cmp byte [choice], '2'
    je hextobcd
    cmp byte [choice], '3'
    je exit
    jmp lp1        ; in case invalid input

bcdtohex:
    m 1, msg1, l1
    m 0, input, 6
    mov qword [multi], 10000
    mov qword [sum], 0
    mov rsi, input
    mov rcx, 5

lp:
    mov rax, 0
    mov al, byte [rsi]
    sub al, '0'
    mov rbx, qword [multi]
    mul rbx
    add qword [sum], rax
    mov rax, qword [multi]
    mov rbx, 10
    div rbx
    mov qword [multi], rax
    inc rsi
    dec rcx
    jnz lp

    mov rax, qword [sum]
    call pro
    jmp lp1

hextobcd:
    m 1, msg1, l1
    m 0, input, 5
    call accept_procedure

    mov rax, qword [sum1]
    mov rbx, 10
    mov rsi, result1 + 15
    mov rcx, 0          ; count digits

bcd:
    xor rdx, rdx
    div rbx
    add dl, 30h
    mov [rsi], dl
    dec rsi
    inc rcx
    cmp rax, 0
    jne bcd

    inc rsi             ; point to first valid digit
    m 1, rsi, rcx
    jmp lp1

exit:
    mov rax, 60
    mov rdi, 0
    syscall

pro:
    mov rdi, result1
    mov rbx, rax
    mov rcx, 16

a:
    rol rbx, 4
    mov al, bl
    and al, 0Fh
    cmp al, 09h
    jg b1
    add al, 30h
    jmp b2

b1:
    add al, 37h

b2:
    mov byte [rdi], al
    inc rdi
    dec rcx
    jnz a

    m 1, result1, 16
    ret

accept_procedure:
    mov rsi, input
    mov rcx, 4
    xor rbx, rbx
    xor rax, rax

loop1:
    rol rbx, 4              ; shift left 4 bits
    mov al, byte [rsi]
    cmp al, 39h
    jg upper_case
    sub al, 30h
    jmp add_digit

upper_case:
    sub al,37h

add_digit:
    add bl, al
    inc rsi
    dec rcx
    jnz loop1

    mov [sum1], rbx
    ret
