# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
#
# Task:
#
#      9 * 11 * 2 + 4 * 11 * 21
# x = ────────────────────────── = -51.0
#         2^2 - 2 * (11 + 2)

.section .data # global data goes here

msg: .ascii "result is " # output text for a user
msg_len = . - msg # length of output text
buffer: .space 6 # store a ascii result value with zero byte

.section .text # code goes here

.global _start # set an entry label
_start:
        movq $11, %rdi # a = 11 in %rdi
        movq $2, %rsi # b = 2 in %rsi
        movq $21, %rdx # c = 21 in %rdx
        movq $-51, %rcx # x = -51 in %rcx
        movq $7, %r8 # y = 7 in %r8

        xorq %r10, %r10 # first temp storage
        xorq %r11, %r11 # second temp storage

        imulq $9, %rdi, %r10 # 9 * 11 = 99, stored in %r10
        imulq %rsi, %r10 # 2 * 99 (from %r10) = 198, stored in %r10
        imulq $4, %rdi, %r11 # 4 * 11 = 44, stored in %r11
        imulq %rx, %r11 # 44 (from %r11) * 21 = 924, stored in %r11
        addq %r11, %r10 # 198 + 924 = 1122, stored in %r10
        push %r10 # push top expression result to stack
        
        imulq %rsi, %rsi, %r10 # 2 (from %rsi) * 2 (from %rsi) = 4, stored in %r10
        movq %rdi, %r11 # move 11 from %rdi into %r11 temp storage for addition
        addq $2, %r11 # 11 (from %rdi) + 2 = 13, stored in %r11
        imulq $2, %r11 # 2 * 13 = 26, stored in %r11
        subq %r10, %r11 # 4 (from $r10) - 26 = -22, stored in %r11

        pop %rdx # restore result of top expression into %rdx
        imulq %r11 # 1122 (from %rdx) / -22 (from %r11) = -51.0, stored in %rax

        movq %rax, %rdi # move the result into %rdi to preserve %rax
        lea buffer(%rip), %rsi # load buffer address into %rsi
        movq $0, %rcx # clear %rcx to count number of digits
        jmp convert # convert result value to ascii

convert:
        xorq %rdx, %rdx # clear %rdx to avoid integer division overflow
        movq $10, %rbx # set divisor to 10
        idivq %rbx # divide result from %rdi by 10 from %rbx
        addq $'0', %rdx # convert to ascii by offset from adding
        movb %dl, (%rsi) # store converted digit in buffer
        incq %rsi # move the pointer by offset of 1 to the next position
        incq %rcx # increment the digit counter
        testq %rax, %rax # check if quotient is zero
        jnz convert # if not zero, repeat the convertation step
        jmp print_message # else print the value from the buffer with the message

print_message:
        movq $1, %rax # number 1 is a syscall for `write`
        movq $1, %rdi # number 1 is a fd for `stdout`
        lea msg(%rip), %rsi # address of the message
        movq $msg_len, %rdx # message length
        syscall # call a syscall
        jmp print_digit # print the digits from a value

print_digit:
        movq $1, %rax # number 1 is a syscall for `write`
        movq $1, %rdi # number 1 is a fd for `stdout`
        movb (%rsi), %al # load the byte of value to print
        syscall # call a syscall
        decq %rsi # move to the previous digit
        decq %rdx # decrement digit count
        jnz print_digits # if there are more digits to print, then repeat
        jmp exit # else exit at the end of the program

exit:
        movq $60, %rax # number 60 is a syscall for `exit`
        xorq %rdi, %rdi # make return code a `0` for success
        syscall # call a syscall
