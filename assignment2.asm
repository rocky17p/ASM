section .data
    ipmsg db "Enter a string", 0xa
    ipmsglen equ $-ipmsg
    opmsg db "The length of the string is: ",0xa
    opmsglen equ $-opmsg

section .bss
    str1 resw 100       ; string whose length is to be found
    result resb 50      ; length of str1 ka variable
    ctr resb 1          ; counter

%macro func 4             ; 4 args -> 1, 2, 3, 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro func

section .text
    global _start
    _start:
        func 1, 1, ipmsg, ipmsglen
        func 0, 0, str1, 100
        mov rbx, rax
        mov byte[ctr], 16
        mov rbp, result

        back:   rol rbx, 04H  
                mov al, bl
                AND al, 0FH
                cmp al, 09H
                jg add_37
                add al, 30H
                jmp skip 
        
        add_37: add al, 37H

        skip:   mov byte[rbp], al
                add rbp, 01
                dec byte[ctr]
                jnz back

        func 1, 1, opmsg, opmsglen
        func 1, 1, result, 16

        mov rax, 60
        mov rdi, 0
        syscall
