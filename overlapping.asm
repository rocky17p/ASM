Program:
section .data
 srcblock db 01, 02, 03, 04, 05, 00, 00, 00, 00, 00
 menu db "Overlapped Block Transfer", 10
 db "1 - Without String Instructions", 10
 db "2 - With String Instructions", 10
 db "3 - Exit", 10, 0
 menu_len equ $ - menu
 enter_pos db "Enter position: ", 0
 pos_len equ $ - enter_pos
 choice db "Enter choice: ", 0
 choice_len equ $ - choice
 newline db 10, 0
section .bss
 ch1 resb 2
 pos resb 2
 hex_output resb 30
section .text
 global _start
_start:
 mov rsi, menu
 mov rdx, menu_len
 call display_msg
 mov rsi, choice
 mov rdx, choice_len
 call display_msg
 mov rsi, ch1
 mov rdx, 2
 call read_input
 movzx rax, byte [ch1]
 sub rax, '0'
 mov [ch1], al 
 mov rsi, enter_pos
 mov rdx, pos_len
 call display_msg
 mov rsi, pos
 mov rdx, 2
 call read_input
 movzx rax, byte [pos]
 sub rax, '0'
 mov [pos], al
 cmp byte [ch1], 1
 je WOS
 cmp byte [ch1], 2
 je WS
 cmp byte [ch1], 3
 je exit
 jmp exit
WOS:
 mov rsi, srcblock + 4
 mov rdi, rsi
 add rdi, [pos]
 mov rcx, 5
blockup1:
 mov al, [rsi]
 mov [rdi], al
 dec rsi
 dec rdi
 loop blockup1
 jmp display_srcblock
WS:
 mov rsi, srcblock + 4
 mov rdi, rsi
 add rdi, [pos]
 mov rcx, 5
 std
 rep movsb
 jmp display_srcblock
display_srcblock:
 mov rsi, srcblock
 mov rdi, hex_output
 mov rcx, 10
hex_loop:
 mov al, [rsi]
 shr al, 4
 add al, '0'
 cmp al, '9'
 jbe store_high
 add al, 7
store_high:
 mov [rdi], al
 inc rdi
 mov al, [rsi]
 and al, 0Fh
 add al, '0'
 cmp al, '9'
 jbe store_low
 add al, 7
store_low:
 mov [rdi], al
 inc rdi
 mov byte [rdi], ' '
 inc rdi
 inc rsi
 loop hex_loop
 mov byte [rdi-1], 10
 mov rsi, hex_output
 mov rdx, 30
 call display_msg
exit:
 mov rax, 60
 xor rdi, rdi
 syscall
display_msg:
 mov rax, 1
 mov rdi, 1
 syscall
 ret
read_input:
 mov rax, 0
 mov rdi, 0
 syscall
 ret
