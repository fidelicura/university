# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64 Linux.
#
# Tasks:
#
# a = 11, b = 2, c = 21
# 
#      9 * 11 * 2 + 4 * 11 * 21
# x = ────────────────────────── = -51
#         2^2 - 2 * (11 + 2)
#
#          -51 * 21 - 2^2
# y = ────────────────────────── = 7
#      16 * (11 - 14) + 2 * -51

.section .rodata

        msg: .asciz "result is -51 and 7\n"
        msg_len = . - msg

        a: .8byte 11
        b: .8byte 2
        c: .8byte 21

.section .bss

        .lcomm x, 8
        .lcomm y, 8

.section .text

        .global _start

_start:
        # movq $11, %rdi # a = 11 in %rdi
        # movq $2, %rsi # b = 2 in %rsi
        # movq $21, %rdx # c = 21 in %rdx
        # movq $-51, %rcx # x = -51 in %rcx
        # movq $7, %r8 # y = 7 in %r8

        /* CALCULATION OF `x` */

        imulq $9, a, %r10     # 9 * 11 (from a) = 99, stored in %r10
        imulq b, %r10         # 2 * 99 (from %r10) = 198, stored in %r10
        imulq $4, a, %r11     # 4 * 11 (from a) = 44, stored in %r11
        imulq c, %r11         # 44 (from %r11) * 21 = 924, stored in %r11
        addq %r11, %r10       # 198 + 924 = 1122, stored in %r10
        pushq %r10            # save top expression result via pushing into stack
        
        movq b, %r10          # move 2 from b into $r10 temp storage for further multiplication
        imulq %r10, %r10      # 2 (from %r10) * 2 (from %r10) = 4, stored in %r10
        movq a, %r11          # move 11 from a into %r11 temp storage for further addition
        addq $2, %r11         # 11 (from %r11) + 2 = 13, stored in %r11
        imulq $2, %r11        # 2 * 13 (from %r11) = 26, stored in %r11
        subq %r11, %r10       # 4 (from %r10) - 26 (from %r11) = -22, stored in %r10
        popq %rax             # restore result of top expression into %rbx
        cqto
        idivq %r10            # 1122 (from %rax) / -22 (from %r10) = -51.0, stored in %rax
        movq %rax, x          # save result into uninitialized variable

        /* CALCULATION OF `y` */

        movq c, %rax          # move 21 (from c) into %rax temp storage for further multiplication
        imulq x, %rax         # -51 (from x) * 21 (from %rax) = -1071, stored in %rax
        movq b, %rsi          # move 2 (from b) into %rsi temp storage for further multiplication 
        imulq %rsi, %rsi      # 2 (from %rsi) * 2 (from %rsi) = 4, stored in %rsi
        subq %rsi, %rax       # -1071 (from %rax) - 4 (from %rsi) = -1075, stored in %rax

        movq a, %rdi          # move 11 from a into %rdi for further subtraction
        subq $14, %rdi        # 11 (from %rdi) - 14 = -3, stored in %rdi
        imulq $16, %rdi       # 16 * (-3) (from %rdi) = -48, stored in %rdi 
        mov x, %rcx           # move -51 from x into %rcx for further multiplication
        imulq $2, %rcx        # 2 * (-51) (from %rcx) = -102, stored in %rcx
        addq %rcx, %rdi       # -48 (from %rcx) + (-102) (from %rdi) = -150, stored in %rdi

        /* RESULT CALCULATION */

        cqto
        idivq %rdi            # -1075 (from %rax) / (-150) (from %rdi) = 7, stored in %rax
        movq %rax, y          # save result into uninitialized variable
        
        /* PROLOGUE JUMP */

        jmp print_message     # print the predefined message for the user

print_message:
        movq $1, %rax        # number 1 is a syscall for `write`
        movq $1, %rdi        # number 1 is a fd for `stdout`
        movq $msg, %rsi      # address of the message
        movq $msg_len, %rdx  # message length
        syscall              # call a syscall
        jmp exit             # exit at the end of the program

exit:
        movq $60, %rax   # number 60 is a syscall for `exit`
        xorq %rdi, %rdi  # make return code a `0` for success
        syscall          # call a syscall
