# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
#
# Task:
#
# Find two smallest values and their indexes in array.

.section .rodata # global constants go here

        # platform-specific for x86-64
        .set INT_MAX, 2147483647
        .set INT_SIZE, 4

        .set DEFAULT_IDX, -1

        array_data: .int -10, 40, -2, 6, 80, -1, 3, 12, -7, 5
        array_info:
                array_size = array_info - array_data
                array_length = array_size / 4 - 1 # amortized for zero-based index

.section .text # code goes here

        .global _start # set an entry label

_start:
        movq $INT_MAX, %r12 # first value should equal INT_MAX for unambiguity
        movq $INT_MAX, %r13 # second value should equal INT_MAX for unambiguity
        movq $DEFAULT_IDX, %r14 # first index should equal -1
        movq $DEFAULT_IDX, %r15 # second index should equal -1

        movq $array_length, %rcx # store a length as a counter for a loop
        L_aux:
                movsx array_data(, %rcx, INT_SIZE), %edx # store array[i] value in %rdx register, amortized by extension to 64-bit register %rdx
                movsxd %edx, %rdx # clear upper 32 bits after op
                cmpq %r12, %rdx # check if array[i] stored in %rdx is less than first value stored in %r12
                jl L_first
                cmpq %r13, %rdx # check if array[i] stored in %rdx is less than second value stored in %r13
                jl L_second
                jmp L_step # nothing checked, go to the next iteration

L_first:
        movq %rdx, %r12 # store array[i] value as first value
        movq %rcx, %r14 # store i index as first index
        jmp L_step # continue loop iteration

L_second:
        cmpq %r12, %rdx # check if array[i] stored in %rdx is not equal to first value stored in %r12
        je L_step # first value is equal to array[i] value, so we go to the next iteration
        movq %rdx, %r13 # otherwise, store array[i] value as first value
        movq %rcx, %r15 # and store i index as first index
        jmp L_step # continue loop iteration

L_step:
        decq %rcx # decrement loop counter value
        jnz L_aux # loop is not finished, go to the next iteration
        jmp exit # loop is finished, go to program exit

exit:
        movq $60, %rax # number 60 is a syscall for `exit`
        xorq %rdi, %rdi # make return code a `0` for success
        syscall # call a syscall
