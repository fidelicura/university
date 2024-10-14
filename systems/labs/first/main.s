# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
#
# Tasks:
#
#      9 * 11 * 2 + 4 * 11 * 21
# x = ────────────────────────── = -51
#         2^2 - 2 * (11 + 2)
#
#          -51 * 21 - 2^2
# y = ────────────────────────── = 7
#      16 * (11 - 14) + 2 * -51

.section .rodata # global constants go here

        msg: .asciz "result is -51 and 7\n" # output text for a user
        msg_len = . - msg # length of output text

.section .text # code goes here

        .global _start # set an entry label

_start:
        # PREPARATIONS

        movq $11, %rdi # a = 11 in %rdi
        movq $2, %rsi # b = 2 in %rsi
        movq $21, %rdx # c = 21 in %rdx
        movq $-51, %rcx # x = -51 in %rcx
        movq $7, %r8 # y = 7 in %r8

        # FIRST ITERATION

        xorq %r10, %r10 # first temp storage
        xorq %r11, %r11 # second temp storage

        imulq $9, %rdi, %r10 # 9 * 11 = 99, stored in %r10
        imulq %rsi, %r10 # 2 * 99 (from %r10) = 198, stored in %r10
        imulq $4, %rdi, %r11 # 4 * 11 = 44, stored in %r11
        imulq %rdx, %r11 # 44 (from %r11) * 21 = 924, stored in %r11
        addq %r11, %r10 # 198 + 924 = 1122, stored in %r10
        pushq %r10 # save top expression result via pushing into stack
        
        movq %rsi, %r10 # move 2 from %rsi into $r10 temp storage for further multiplication
        imulq %r10, %r10 # 2 (from %r10) * 2 (from %r10) = 4, stored in %r10
        movq %rdi, %r11 # move 11 from %rdi into %r11 temp storage for further addition
        addq $2, %r11 # 11 (from %rdi) + 2 = 13, stored in %r11
        imulq $2, %r11 # 2 * 13 = 26, stored in %r11
        subq %r11, %r10 # 4 (from %r10) - 26 (from %r11) = -22, stored in %r10
        popq %rax # restore result of top expression into %rax
        xorq %rdx, %rdx # clear the quotient register to not to divide by quotient
        idivq %r10 # 1122 (from %rax) / -22 (from %r10) = -51.0, stored in %rdx

        # SECOND ITERATION

        xorq %r10, %r10 # first temp storage
        xorq %r11, %r11 # second temp storage
        movq $21, %rdx # restore 21 in %rdx

        imulq %rcx, %rdx # -51 (from %rcx) * 21 (from %rdx) = -1071, stored in %rdx
        imulq %rsi, %rsi # 2 (from %rsi) * 2 (from %rsi) = 4, stored in %r10
        subq %rsi, %rdx # -1071 (from %rdx) - 4 (from %rsi) = -1075, stored in %rdx
        pushq %rdx # save top expression result via pushing into stack

        subq $14, %rdi # 11 (from %rdi) - 14 = -3, stored in %rdi
        imulq $16, %rdi # 16 * (-3) (from %rdi) = -48, stored in %rdi 
        imulq $2, %rcx # 2 * (-51) (from %rcx) = -102, stored in %rcx
        addq %rcx, %rdi # -48 (from %rcx) + (-102) (from %rdi) = -150, stored in %rdi
        popq %rax # restore result of top expression into %rax
        # sign extend %rax into %rdx because we divide negative integer
        # and we need correct bits up to extension at concatenation of registers
        cqto
        idivq %rdi # -1075 (from %rax) / (-150) (from %rdi) = 7, stored in %rax
        
        # END OF ITERATIONS

        jmp print_message # print the predefined message for the user

print_message:
        movq $1, %rax # number 1 is a syscall for `write`
        movq $1, %rdi # number 1 is a fd for `stdout`
        movq $msg, %rsi # address of the message
        movq $msg_len, %rdx # message length
        syscall # call a syscall
        jmp exit # exit at the end of the program

exit:
        movq $60, %rax # number 60 is a syscall for `exit`
        xorq %rdi, %rdi # make return code a `0` for success
        syscall # call a syscall
