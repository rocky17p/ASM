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

%macro rw 3
    mov rax, %1       ; syscall number: 0 (read), 1 (write)
    mov rdi, %1       ; file descriptor: 0 (stdin), 1 (stdout)
    mov rsi, %2       ; buffer
    mov rdx, %3       ; length
    syscall
%endmacro

section .text
    global _start

_start:
    rw 1, nummsg, nummsg_len
    rw 0, inputnum, 2

    call accept_proc
    mov [num1], bl

    rw 1, resmsg, resmsg_len

    mov al, [num1]
    cmp al, 01h
    jbe end_fact

    mov bl, [num1]
    call fact_proc

    mov rbx, rax
    call disp64_proc
    jmp exit

end_fact:
    rw 1, z_factmsg, z_factmsg_len

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

    rw 1, char_ans, 16
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
