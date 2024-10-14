# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
#
# Tasks:
#
#     ( a + b,   if a / b < 0
# y = < a * b^2, if a / b = 0
#     ( 10 + b,  if a / b > 0

.section .text # code goes here

        .global _start # set an entry label

_start:
        jmp first

# CONDITIONS

first:
        movq $4385147783900017322, %rax # a = 4385147783900017322 in %rax
        movq $2305849009213693952, %rbx # b = 2305849009213693952 in %rbx
        idivq %rbx # a (from %rax) / b (from %rbx) = result, stored in %rax
        testq %rax, %rax # check if result (from %rax) is zero via logical and
        jg greater

second:
        movq $0, %rax # a = 0 in %rax
        movq $2308843009213693952, %rbx # b = 2308843009213693952 in %rbx
        cqto # extend upon %rdx with correct sign because of previous calculations
        idivq %rbx # a (from %rax) / b (from %rbx) = result, stored in %rax
        testq %rax, %rax # check if result (from %rax) is zero via logical and
        je equal

third:
        movq $4385147783900017322, %rax # a = 4385147783900017322 in %rax
        cqto # extend upon %rdx with correct sign because of previous calculations
        movq $-2305843009213693952, %rbx # b = -2305843009213693952 in %rbx
        idivq %rbx # a (from %rax) / b (from %rbx) = result, stored in %rax
        testq %rax, %rax # check if result (from %rax) is zero via logical and
        jl lesser

# COMPARERS

greater:
        addq $10, %rbx # 10 + value from %rbx = result, stored in %rbx
        jmp second # go to next condition

equal:
        imulq %rbx, %rbx # %rbx^2 = result, stored in %rbx
        imulq %rax, %rbx # value from %rax * value from %rbx = result, stored in %rbx
        jmp third # go to next condition

lesser:
        addq %rax, %rbx # value from %rax + value from %rbx = result, stored in %rbx
        jmp exit # go to end of a program

# FINISH

exit:
        movq $60, %rax # number 60 is a syscall for `exit`
        xorq %rdi, %rdi # make return code a `0` for success
        syscall # call a syscall
