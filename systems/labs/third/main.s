# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64 Linux.
#
# Task:
#
# Find two smallest values and their indexes in array.

.section .rodata

        # platform-specific for x86-64
        .set LLONG_MAX, 2147483647
        .set LLONG_SIZE, 8

        .set DEFAULT_IDX, -1

        array_data: .8byte -10, 40, -2, 6, 80, -1, 3, 12, -7, 5
        array_info:
                array_size = array_info - array_data
                array_length = array_size / 8 - 1 # amortized for zero-based index

.section .data

        first_val: .8byte LLONG_MAX
        second_val: .8byte LLONG_MAX

        first_idx: .8byte DEFAULT_IDX
        second_idx: .8byte DEFAULT_IDX

.section .text

        .global _start

_start:
        movq  $array_length, %rcx  # store a length as a counter for a loop
        L_aux:
                movslq array_data(, %rcx, LLONG_SIZE), %rdx  # %rdx = array[i] with amortisation of signed long by upper bits extension to quad register %rdx, due to int value
                cmpq first_val, %rdx                       # array[i] (from %rdx) is less than first (from %r12)
                jle L_first
                cmpq second_val, %rdx                      # array[i] (from %rdx) is less than second (from %r13)
                jl L_second
                jmp L_step

L_first:
        movq  first_val, %rax        # copy previous first value into temp register
        movq  first_idx, %rbx        # copy previous first index into temp register
        movq  %rax, second_val       # copy from temp register in second value
        movq  %rbx, second_idx       # copy from temp register in second index
        movq  %rdx, first_val        # store array[i] value as first value
        movq  %rcx, first_idx        # store i index as first index
        jmp   L_step

L_second:
        movq  %rdx, second_val  # otherwise, store array[i] value as first value
        movq  %rcx, second_idx  # and store i index as first index
        jmp   L_step

L_step:
        decq  %rcx    # decrement loop counter value
        jge   L_aux
        jmp   exit

exit:
        movq     $60, %rax   # number 60 is a syscall for `exit`
        xorq     %rdi, %rdi  # make return code a `0` for success
        syscall
