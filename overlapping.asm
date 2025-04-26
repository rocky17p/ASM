section .data
    srcblock db 01, 02, 03, 04, 05, 00, 00, 00, 00, 00

    menu db "Overlapped Block Transfer", 10
         db "1 - Without String Instructions", 10
         db "2 - With String Instructions", 10
         db "3 - Exit", 10, 0
    menu_len equ $ - menu

    enter_pos db "Enter position: ", 0
    pos_len   equ $ - enter_pos

    choice db "Enter choice: ", 0
    choice_len equ $ - choice

section .bss
    ch1        resb 2
    pos        resb 2
    hex_output resb 30

section .text
    global _start
    
    ; Macro for Read/Write
    %macro rw 3
      mov rax,%1
      mov rdi,%1
      mov rsi,%2
      mov rdx,%3
      syscall
    %endmacro

_start:
    ; Display menu
    rw 1,menu,menu_len

    ; Prompt for choice
    rw 1,choice,choice_len

    ; Read choice
    rw 0,ch1,2

    ; Prompt for position
    rw 1,enter_pos,pos_len

    ; Read position
    rw 0,pos,2

    ; Branch based on choice (directly comparing ASCII characters)
    cmp byte [ch1], '1'
    je WOS

    cmp byte [ch1], '2'
    je WS

    cmp byte [ch1], '3'
    je exit

    jmp exit

; Without String Instructions
WOS:
    mov rsi, srcblock + 4
    mov rdi, rsi

    ; Now adjust rdi based on ASCII position
    movzx rax, byte [pos]   ; Load ASCII value of pos
    sub rax, 30h           ; Convert ASCII digit to number
    add rdi, rax

    mov rcx, 5

blockup1:
    mov al, [rsi]
    mov [rdi], al
    dec rsi
    dec rdi
    loop blockup1

    jmp display_srcblock

; With String Instructions
WS:
    mov rsi, srcblock + 4
    mov rdi, rsi

    ; Adjust rdi based on ASCII position
    movzx rax, byte [pos]   ; Load ASCII value of pos
    sub rax, 30h           ; Convert ASCII digit to number
    add rdi, rax

    mov rcx, 5

    std                 ; Set direction flag for backward copying
    rep movsb           ; Move bytes
    cld                 ; Clear direction flag back to default

    jmp display_srcblock

; Display the srcblock in hex format without spaces
display_srcblock:
    mov rsi, srcblock     ; source pointer
    mov rdi, hex_output   ; destination pointer
    mov rcx, 10           ; 10 bytes to process

loop1:
    mov bl, [rsi]         ; load one byte
    rol rbx, 4            ; rotate left 4 bits to bring high nibble to low nibble
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

    mov bl, [rsi]         ; reload original byte
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

    inc rsi              ; move to next byte
    dec rcx
    jnz loop1

    ; After all 10 bytes processed, add newline
    mov byte [rdi], 10

    ; Output result
    rw 1, hex_output, 30

    jmp exit

exit:
    mov rax, 60          ; syscall: exit
    xor rdi, rdi         ; exit code 0
    syscall
