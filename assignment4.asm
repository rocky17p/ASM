section .data
    menu db 10, 13, "Enter the choice",
        db 10, 13, "Choice 1: Addition",
        db 10, 13, "Choice 2: Subtraction",
        db 10, 13, "Choice 3: Multiplication",
        db 10, 13, "Choice 4: Division",
        db 10, 13, "Choice 5: Exit"
    menulen equ $-menu

    choice db 10, 13, "Enter Choice: "
    choicelen equ $-choice

    addmsg db 10, 13, "Result of Addition is: "
    addmsglen equ $-addmsg

    submsg db 10, 13, "Result of Subtraction is: "
    submsglen equ $-submsg

    mulmsg db 10, 13, "Result of Multiplication is: "
    mulmsglen equ $-mulmsg

    divmsg db 10, 13, "Result of Division is (Quotient): "
    divmsglen equ $-divmsg

    remmsg db 10, 13, "Remainder is: "
    remmsglen equ $-remmsg

    array dq 0000000000000006H ,  0000000000000002H  ; Example numbers: 6 and 2 

section .bss
    c resb 2
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
    xor rdi, rdi
    syscall
%endmacro

section .text
global _start
_start:
    mainloop:
        rw 1, menu, menulen
        rw 1, choice, choicelen
        rw 0, c, 2

        cmp byte [c], '1'
        je case1
        cmp byte [c], '2'
        je case2
        cmp byte [c], '3'
        je case3
        cmp byte [c], '4'
        je case4
        cmp byte [c], '5'
        je case5
        jmp mainloop

    case1:
        call addition
        exit
    case2:
        call subtraction
        exit
    case3:
        call multiplication
        exit
    case4:
        call division
        exit
    case5:
        exit

addition:
    rw 1, addmsg, addmsglen
    mov rbp, array
    mov rbx, [rbp]
    add rbx, [rbp+8]
    call hexToAscii
    rw 1, num, 16
    ret

subtraction:
    rw 1, submsg, submsglen
    mov rbp, array
    mov rbx, [rbp]
    sub rbx, [rbp+8]
    call hexToAscii
    rw 1, num, 16
    ret

multiplication:
    rw 1, mulmsg, mulmsglen
    mov rsi, array
    mov rax, [rsi]
    mov rbx, [rsi+8]
    mul rbx
    mov rbx, rax
    call hexToAscii
    rw 1, num, 16
    ret

division:
    rw 1, divmsg, divmsglen

    mov rsi, array
    mov rax, [rsi]          ; Load dividend = 6
    xor rdx, rdx            ; Clear RDX before division
    div qword [rsi+8]       ; RAX = Quotient, RDX = Remainder

    push rdx                ; Save remainder on stack

    ; Print Quotient
    mov rbx, rax            ; Store quotient in RBX for conversion
    call hexToAscii         ; Convert to ASCII
    rw 1, num, 16           ; Print quotient

    ; Print Remainder
    rw 1, remmsg, remmsglen
    pop rbx                 ; Restore remainder from stack
    call hexToAscii         ; Convert remainder to ASCII
    rw 1, num, 16           ; Print remainder

    ret

hexToAscii:
    mov rcx, 16
    mov rdi, num
    .loop:
        rol rbx, 4
        mov al, bl
        and al, 0x0F
        cmp al, 9
        jle .digit
        add al, 7
    .digit:
        add al, 0x30
        mov [rdi], al
        inc rdi
        dec rcx
        jnz .loop
    ret
