section .data
        m1 db "enter 5 64 bit number",10
        len equ $-m1
section .bss
        var resb 85
section .text
        global _start
        %macro rw 3
        mov rax,%1
        mov rdi,%1
        mov rsi,%2
        mov rdx,%3
        syscall
        %endmacro
_start:
        rw 1,m1,len
        mov r8,5
        mov rsi,var
start_loop:
        rw 0,rsi,17
        rw 1,rsi,17
        add rsi,17
        dec r8
        jnz start_loop

        mov rax,60
        mov rdi,0
        syscall
