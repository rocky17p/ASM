section .data
    srcblock db 01h, 02h, 03h, 04h, 05h      ; source block
    destblock db 00h, 00h, 00h, 00h, 00h      ; destblock manual 00s

    menu db "Non-Overlapped Block Transfer", 10
         db "1 - Without String Instructions", 10
         db "2 - With String Instructions", 10
         db "3 - Exit", 10, 0
    menu_len equ $ - menu

    choice db "Enter choice: ", 0
    choice_len equ $ - choice

section .bss
    ch1        resb 2
    hex_output resb 30

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
    ; Display menu
    rw 1,menu,menu_len

    ; Prompt for choice
    rw 1,choice,choice_len

    ; Read choice
    rw 0,ch1,2

    ; Branch based on choice
    cmp byte [ch1], '1'
    je WOS

    cmp byte [ch1], '2'
    je WS

    cmp byte [ch1], '3'
    je exit

    jmp exit

; Without String Instructions
WOS:
    mov rsi, srcblock       ; source start
    mov rdi, destblock      ; destination start
    mov rcx, 5              ; 5 bytes to copy

copy_loop1:
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    loop copy_loop1

    jmp display_destblock

; With String Instructions
WS:
    mov rsi, srcblock
    mov rdi, destblock
    mov rcx, 5

    cld             ; clear direction flag (forward)
    rep movsb

    jmp display_destblock

; Display destblock
display_destblock:
    mov rsi, destblock
    mov rdi, hex_output
    mov rcx, 5

loop1:
    mov bl, [rsi]
    rol rbx, 4
    mov al, bl
    and al, 0Fh
    cmp al, 9
    jg b1
    add al, 30h
    jmp b2

b1:
    add al, 37h

b2:
    mov [rdi], al
    inc rdi

    mov bl, [rsi]
    and bl, 0Fh
    mov al, bl
    cmp al, 9
    jg b3
    add al, 30h
    jmp b4

b3:
    add al, 37h

b4:
    mov [rdi], al
    inc rdi

    inc rsi
    dec rcx
    jnz loop1

    mov byte [rdi], 10

    ; Output result
    rw 1, hex_output, 30

    jmp exit

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
