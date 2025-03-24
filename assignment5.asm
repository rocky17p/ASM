section .data
    arr dq 0000000000000008H, 0000000000000001H, 0000000000000009H, -000000000000000AH, -0000000000000007H
    arrlen db 05H
    
    msg db "Array: "
    msglen equ $-msg
    
    msg1 db "Count of Positive numbers: "
    msg1len equ $-msg1
    msg2 db "Count of Negative numbers: "
    msg2len equ $-msg2
    
    pos db 00H
    nig db 00H
    
    newline db 10

    temp db 05H

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


    ; Using cmp
    mov rdi, arr
    movzx rcx, byte[arrlen]
    back:
      cmp qword[rdi], 00H
      je b2
      jl b1
      add byte[pos], 01H
      jmp b2
      
      b1: add byte[nig], 01H
            
      b2: add rdi, 8
      dec rcx
      jnz back
    
    movzx rbx, byte[pos]
    call hexToAscii
    rw 1, msg1, msg1len
    rw 1, num, 16
    rw 1, newline, 1
    
    movzx rbx, byte[nig]
    call hexToAscii
    rw 1, msg2, msg2len
    rw 1, num, 16
    rw 1, newline, 1
    
    exit
    
    
    ; Using carry flag by rotating number by 1 bit
    ; mov rdi, arr
    ; movzx rcx, byte[arrlen]
    
    ; back:
    ;   mov rax, [rdi]
    ;   cmp rax, 00H
    ;   je b2
    ;   rol rax, 1
    ;   jc b1
    ;   add byte[pos], 01H
    ;   jmp b2
      
    ;   b1: add byte[nig], 01H
            
    ;   b2: add rdi, 8
    ;   dec rcx
    ;   jnz back
    
    ; movzx rbx, byte[pos]
    ; call hexToAscii
    ; rw 1, msg1, msg1len
    ; rw 1, num, 16
    ; rw 1, newline, 1
    
    ; movzx rbx, byte[nig]
    ; call hexToAscii
    ; rw 1, msg2, msg2len
    ; rw 1, num, 16
    ; rw 1, newline, 1
    
    ; exit
    
    ; Using sign flag by adding 0 to each number
    ; mov rdi, arr
    ; movzx rcx, byte[arrlen]
    
    ; back:
    ;   mov rax, [rdi]
    ;   cmp rax, 00H
    ;   je b2
    ;   add rax, 00H
    ;   js b1
    ;   add byte[pos], 01H
    ;   jmp b2
      
    ;   b1: add byte[nig], 01H
            
    ;   b2: add rdi, 8
    ;   dec rcx
    ;   jnz back
    
    ; movzx rbx, byte[pos]
    ; call hexToAscii
    ; rw 1, msg1, msg1len
    ; rw 1, num, 16
    ; rw 1, newline, 1
    
    ; movzx rbx, byte[nig]
    ; call hexToAscii
    ; rw 1, msg2, msg2len
    ; rw 1, num, 16
    ; rw 1, newline, 1
    
    ; exit
      
    ; Hex to ascii procedure
    hexToAscii:
    mov rcx, 16
    mov rdi, num

    loop1:
        rol rbx, 04H
        mov al, bl
        and al, 0FH
        cmp al, 09
        jg a1
        add al, 30H
        jmp a2

        a1: add al, 37H

        a2: mov byte[rdi], al
            inc rdi
            dec rcx
            jnz loop1

    ret
