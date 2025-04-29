; Factorial of a number

section .data
    nummsg      db 10, "program to find factorial"
    nummsg_len  equ $ - nummsg

    resmsg      db 10, " factorial is:"
    resmsg_len  equ $ - resmsg

    z_factmsg   db 10, "0000 0001"
    z_factmsg_len equ $ - z_factmsg

section .bss
    result      resb 4
    num1        resb 1
    num2        resb 1
    inputnum    resb 3
    char_ans    resb 16

%macro screen_io 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .text
    global _start

_start:
    screen_io 1, 1, nummsg, nummsg_len
    screen_io 0, 0, inputnum, 02

    call accept_proc
    mov [num1], bl

    screen_io 1, 1, resmsg, resmsg_len

    mov al, [num1]
    cmp al, 01h
    jbe end_fact

    mov bl, [num1]
    call fact_proc

    mov rbx, rax
    call disp64_proc
    jmp exit

end_fact:
    screen_io 1, 1, z_factmsg, z_factmsg_len

exit:
    mov rax, 60
    mov rdi, 0
    syscall
    ret

fact_proc:
    cmp bl, 1
    jne do_cal
    mov ax, 1
    ret

do_cal:
    push rbx
    dec bl
    call fact_proc
    pop rbx
    mul bl
    ret

disp64_proc:
    mov rdi, char_ans
    mov rbx, rax
    mov rcx, 16

disp_loop:
    rol rbx, 4
    mov al, bl
    and al, 0Fh
    cmp al, 09h
    jg disp_letter
    add al, 30h
    jmp store_char

disp_letter:
    add al, 37h

store_char:
    mov [rdi], al
    inc rdi
    dec rcx
    jnz disp_loop

    screen_io 1, 1, char_ans, 16
    ret

accept_proc:
    mov rsi, inputnum
    mov rcx, 2
    xor rbx, rbx
    xor rax, rax

loop1:
    rol rbx, 4
    mov al, [rsi]
    cmp al, 39h
    jg upper_case
    sub al, 30h
    jmp add_digit

upper_case:
    sub al, 37h

add_digit:
    add bl, al
    inc rsi
    dec rcx
    jnz loop1

    ret
