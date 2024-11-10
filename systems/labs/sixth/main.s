# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
#
# Task:
#
# Sort an array in order of odd (by value) elements first, then
# even (again, by value) ones, saving the initial order.
# Determine amount and mean of non-negative numbers in an array.
#
# Expectations:
#
# 1) [-23, 38, -56, -79, 8, 91, -40, -86, -90, 61] => [-23, -79, 91, 61, 38, -56, 8, -40, -86, -90]

        .macro even_odd reg, even, odd
                testb $1, \reg
                jz \even
                jnz \odd
        .endm

        .set LLONG_SIZE, 8

.section .data

        array_data: .8byte -23, 38, -56, -79, 8, 91, -40, -86, -90, 61
        # array_data: .8byte -93, 17, -1, -9, 44, 46, 11
        array_info:
                array_size = array_info - array_data
                array_length = array_size / LLONG_SIZE - 1 # amortized for zero-based index

        .equ mean, 0
        .equ amount, 0

        block:
                .8byte amount
                .8byte mean
                .8byte array_length
                .8byte array_data

.section .text

        .global _start

_start:
        leaq   block(%rip), %rax    # load amount variable
        pushq  %rax                 # store mean variable
        leaq   block+8(%rip), %rax  # load mean variable
        pushq  %rax                 # store mean variable
        pushq  block+16(%rip)       # store array length value
        pushq  block+24(%rip)       # store pointer to the array
        callq  main
        jmp    exit

main:
        # prologue {
        pushq  %rbp
        movq   %rsp, %rbp
        # } prologue
        movq   16(%rbp), %rbx  # load pointer to the array
        movq   24(%rbp), %rcx  # load array length value
        movq   %rcx, %r15      # save array length for further
        movq   32(%rbp), %r10  # load mean variable
        movq   40(%rbp), %r11  # load amount variable
        L_main_aux_start:
                movq      (%rbx, %rcx, LLONG_SIZE), %rax  # store `array[i]` into %rax
                testq     %rax, %rax
                jg        L_main_count
        L_main_aux_end:
                even_odd  %al, L_main_inner_main, L_main_step

L_main_count:
        addq  %rax, (%r10)    # sum of appropriate numbers
        incq  (%r11)          # amount of appropriate numbers
        jmp   L_main_aux_end

L_main_step:
        decq  %rcx              # decrement `i` loop counter
        jge   L_main_aux_start
        jmp   L_main_cond

L_main_inner_main:
        movq      %rcx, %rsi                       # store `j` index
L_main_inner_step:
        cmpq      %r15, %rsi                       # `j < array_length`
        jge       L_main_step
        movq      %rsi, %rdi                       # store future `j + 1` index
        incq      %rdi                             # store `j + 1` index
        movq      (%rbx, %rdi, LLONG_SIZE), %r13   # store `array[j+1]`
        even_odd  %r13b, L_main_step, L_main_swap

L_main_cond:
        movq  (%r10), %rax         # load address of mean variable
        cqto
        divq  (%r11)               # calculate mean by sum divided by amount
        movq  %rax, block+8(%rip)  # store mean in a variable
        movq  (%r11), %rbx         # load address of amount variable
        movq  %rbx, block(%rip)    # store amount in a variable
        jmp   L_main_exit

L_main_swap:
        pushq  %r15
        leaq   (%rbx, %rsi, LLONG_SIZE), %r12  # address of array[j]
        leaq   (%rbx, %rdi, LLONG_SIZE), %r13  # address of array[j+1]
        movq   (%r12), %r14                    # temp = array[j]
        movq   (%r13), %r15                    # get array[j+1]
        movq   %r15, (%r12)                    # array[j] = array[j+1]
        movq   %r14, (%r13)                    # array[j+1] = temp
        incq   %rsi                            # j++
        popq   %r15
        jmp    L_main_inner_step

L_main_exit:
        # epilogue {
        movq   %rbp, %rsp
        popq   %rbp
        retq
        # } epilogue

exit:
        movq     $60, %rax   # number 60 is a syscall for `exit`
        xorq     %rdi, %rdi  # make return code a `0` for success
        syscall              # call a syscall
