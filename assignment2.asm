section .data
    ipmsg db "Enter a string", 0xa        ; Input prompt
    ipmsglen equ $ - ipmsg
    opmsg db "The length of the string is: ", 0xa ; Output prompt
    opmsglen equ $ - opmsg

section .bss
    str1 resw 100          ; Reserve 100 bytes for the input string
    result resb 50         ; Reserve space for result (ASCII length)
    
section .text
    global _start

%macro func 4             ; Macro for syscall (4 args -> 1, 2, 3, 4)
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

_start:
    ; Step 1: Print the input prompt "Enter a string"
    func 1, 1, ipmsg, ipmsglen

    ; Step 2: Read the input string
    func 0, 0, str1, 100        ; sys_read (stdin)

    ; Step 3: Calculate the length of the string
    mov rbx, rax                ; Store the length of the input string (in rax) into rbx
    mov rcx, 16                 ; Set rcx to 16 (we will process 1 byte at a time)

    ; Step 4: Convert the length (stored in rbx) to ASCII and store it in result
    mov rbp, result             ; Point rbp to the result buffer

    back:
        rol rbx, 04h             ; Rotate rbx by 4 bits to shift the next nibble
        mov al, bl               ; Move the lower byte of rbx to al
        AND al, 0Fh              ; Mask the lower 4 bits to get a digit (0-15)
        cmp al, 09h              ; Check if it's greater than 9
        jg add_37                ; If greater than 9, add 37h to convert to 'A'-'F'

        add al, '0'              ; Else add ASCII '0' (convert to '0'-'9')
        jmp skip

    add_37:
        add al, 37h              ; If greater than 9, add 37h to convert to 'A'-'F'

    skip:
        mov [rbp], al            ; Store the result in the result buffer
        inc rbp                  ; Move to the next byte in the result buffer
        dec rcx                  ; Decrement rcx (counter for the loop)
        jnz back                 ; Repeat until rcx reaches zero

    ; Step 5: Print the output message "The length of the string is: "
    func 1, 1, opmsg, opmsglen

    ; Step 6: Print the converted length (stored in result)
    func 1, 1, result, 16        ; Display the length (up to 16 chars)

    ; Step 7: Exit the program
    mov rax, 60                  ; sys_exit
    xor rdi, rdi                 ; Return code 0
    syscall
