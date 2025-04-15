%macro print 2
    mov     rax, 01
    mov     rdi, 01
    mov     rsi, %1
    mov     rdx, %2
    syscall
%endmacro

%macro read 2
    mov     rax, 00
    mov     rdi, 00
    mov     rsi, %1
    mov     rdx, %2
    syscall
%endmacro

%macro exit 0
    mov     rax, 60
    xor     rdi, rdi
    syscall
%endmacro

%macro file_open 1
    mov     rax, 02
    mov     rdi, %1
    mov     rsi, 0
    syscall
%endmacro

%macro file_read 3
    mov     rax, 00
    mov     rdi, %1
    mov     rsi, %2
    mov     rdx, %3
    syscall
%endmacro

%macro file_close 1
    mov     rax, 03
    mov     rdi, %1
    syscall
%endmacro

extern  proc_count_spaces
extern  proc_count_lines
extern  proc_count_char

global  _start
global  buffer
global  filesize
global  count_spaces
global  count_lines
global  count_char
global  input_char

section .bss
filedesc        resq 1
filesize        resq 1
buffer          resb 200

count_spaces    resb 1
count_lines     resb 1
count_char      resb 1

value           resb 2
input_char      resb 2
input_filename  resb 50

section .data
msg_count_spaces    db "The number of spaces is ", 0xA
len_count_spaces    equ $ - msg_count_spaces

msg_count_lines     db "The number of lines is ", 0xA
len_count_lines     equ $ - msg_count_lines

msg_count_char      db "The frequency of given character is ", 0xA
len_count_char      equ $ - msg_count_char

msg_input_char      db "Enter char to find frequency: ", 0xA
len_input_char      equ $ - msg_input_char

line_break          db 0xA

section .text
_start:
    read    input_filename, 50
    dec     rax
    mov     byte [input_filename + rax], 0

    file_open input_filename
    mov     [filedesc], rax

    file_read rax, buffer, 200
    mov     [filesize], rax

    call    proc_count_spaces
    print   msg_count_spaces, len_count_spaces
    mov     rsi, count_spaces
    call    byte_hex_to_ascii

    call    proc_count_lines
    print   msg_count_lines, len_count_lines
    mov     rsi, count_lines
    call    byte_hex_to_ascii

    print   msg_input_char, len_input_char
    read    input_char, 2
    call    proc_count_char
    print   msg_count_char, len_count_char
    mov     rsi, count_char
    call    byte_hex_to_ascii

    mov     rdi, [filedesc]
    file_close rdi

    exit

byte_hex_to_ascii:
    mov     bl, [rsi]
    mov     rdi, value
    mov     rcx, 2

.hex_loop:
    rol     bl, 4
    mov     dl, bl
    and     dl, 0x0F
    cmp     dl, 9
    jbe     .digit
    add     dl, 7
.digit:
    add     dl, '0'
    mov     [rdi], dl
    inc     rdi
    loop    .hex_loop

    print   line_break, 1
    print   value, 2
    print   line_break, 1
    ret

proc.asm

; proc.asm
; Assembly routines for counting spaces, lines, and specific character occurrences

section .text
global proc_count_spaces
global proc_count_lines
global proc_count_char

extern buffer
extern filesize
extern input_char
extern count_spaces
extern count_lines
extern count_char

; Count spaces in buffer
proc_count_spaces:
    xor     rcx, rcx          ; index = 0
    xor     rbx, rbx          ; space counter = 0

.loop1:
    cmp     rcx, [filesize]   ; if index >= filesize, exit loop
    jge     .done1
    mov     al, [buffer + rcx]
    cmp     al, ' '           ; check if space
    jne     .next1
    inc     rbx               ; increment space count
.next1:
    inc     rcx               ; move to next character
    jmp     .loop1
.done1:
    mov     [count_spaces], bl
    ret

; Count new lines (LF = 0xA)
proc_count_lines:
    xor     rcx, rcx
    xor     rbx, rbx

.loop2:
    cmp     rcx, [filesize]
    jge     .done2
    mov     al, [buffer + rcx]
    cmp     al, 0xA           ; line feed
    jne     .next2
    inc     rbx
.next2:
    inc     rcx
    jmp     .loop2
.done2:
    mov     [count_lines], bl
    ret

; Count occurrences of a specific input character
proc_count_char:
    xor     rcx, rcx
    xor     rbx, rbx
    mov     dl, [input_char]  ; character to search for

.loop3:
    cmp     rcx, [filesize]
    jge     .done3
    mov     al, [buffer + rcx]
    cmp     al, dl
    jne     .next3
    inc     rbx
.next3:
    inc     rcx
    jmp     .loop3
.done3:
    mov     [count_char], bl
    ret

test.txt


Hello World
from
Assembly
System Programming
