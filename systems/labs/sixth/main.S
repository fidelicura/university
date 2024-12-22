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
# 1) [-23, 38, -56, -79, 8, 91, -40, -86, -90, 61] => [-23, -79, 91, 61, 38, -56, 8, -40, -86, -90],
# (mean, amount) = (49.5, 4),
# 2) [-93, 17, -1, -9, 44, 46] => [-93, 17, -1, -9, 44, 46],
# (mean, amount) = (35.6, 3).

        .macro even_odd reg, even, odd
                testb $1, \reg
                jz \even
                jnz \odd
        .endm

        .set LLONG_SIZE, 8

.section .data

        first_array_data: .8byte -23, 38, -56, -79, 8, 91, -40, -86, -90, 61
        first_array_info:
                first_array_size = first_array_info - first_array_data
                first_array_length = first_array_size / LLONG_SIZE - 1 # amortized for zero-based index

        second_array_data: .8byte -93, 17, -1, -9, 44, 46
        second_array_info:
                second_array_size = second_array_info - second_array_data
                second_array_length = second_array_size / LLONG_SIZE - 1 # amortized for zero-based index

        # array address (8) + array size (8) + amount (8) + mean (8) +
        # biggest array length (10) * size of each element in array (8)
        # = 112
        # allocation = 8 * 4 + 10 * LLONG_SIZE

        # array address (8) + array size (8) + amount (8) + mean (8)
        # = 32
        # allocation = LLONG_SIZE * 4

        # amount (8) + mean (8)
        # = 16
        allocation = LLONG_SIZE * 2

        first_amount: .8byte 0
        first_mean: .8byte 0

        second_amount: .8byte 0
        second_mean: .8byte 0

.section .text

        .global _start

_start:
        pushq  $first_mean
        pushq  $first_amount
        pushq  $first_array_length
        pushq  $first_array_data     # push array address
        callq  main
        pushq  $second_mean
        pushq  $second_amount
        pushq  $second_array_length
        pushq  $second_array_data    # push array address
        callq  main
        jmp    exit

main:
        # prologue {
        pushq  %rbp
        movq   %rsp, %rbp
        # } prologue
        # locals {
        subq   $allocation, %rsp
        # } locals
        # preserve {
        pushq  %rax
        pushq  %rbx
        pushq  %rcx
        pushq  %rdx
        pushq  %rsi
        pushq  %rdi
        # } preserve
        # aliases {
        #define MEAN_STACK -40(%rbp)
        #define AMOUNT_STACK -32(%rbp)
        #define AMOUNT_LOCATION 40(%rbp)
        #define MEAN_LOCATION 32(%rbp)
        #define SIZE 24(%rbp)
        #define ARRAY 16(%rbp)
        # } aliases
        leaq   MEAN_LOCATION, %r10
        movq   %r10, MEAN_STACK
        leaq   AMOUNT_LOCATION, %r11
        movq   %r11, AMOUNT_STACK
        movq   SIZE, %rcx
        movq   %rcx, %r15
        movq   ARRAY, %rbx
        # movq   16(%rbp), %rax  # store direct block address
        # movq   24(%rax), %rbx  # load pointer to the array
        # movq   16(%rax), %rcx  # load array length value
        # movq   %rcx, %r15      # store array length for future
        # leaq   8(%rax), %r10   # load mean variable address
        # leaq   (%rax), %r11    # load amount variable address
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
        cvtsi2sd  (%r10), %xmm0  # load value of mean variable as float
        cvtsi2sd  (%r11), %xmm1  # load value of amount variable as float
        divsd     %xmm1, %xmm0   # calculate a mean value as float
        movsd     %xmm0, (%r10)  # store mean value in a mean variable
        jmp       L_main_exit

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
        # movq MEAN_STACK, %rax
        # movq %rax, MEAN_VALUE
        # movq AMOUNT_STACK, %rax
        # movq %rax, AMOUNT_VALUE
        # restore {
        popq %rdi
        popq %rsi
        popq %rdx
        popq %rcx
        popq %rbx
        popq %rax
        # } restore
        # freeing {
        addq $allocation, %rsp
        # } freeing
        # epilogue {
        movq   %rbp, %rsp
        popq   %rbp
        retq
        # } epilogue

exit:
        movq     $60, %rax   # number 60 is a syscall for `exit`
        xorq     %rdi, %rdi  # make return code a `0` for success
        syscall              # call a syscall
