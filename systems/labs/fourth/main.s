# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64 Linux.
#
# Task:
#
# Find two smallest values and their indexes in array.
#
# Info:
#
# "User-level applications use as integer registers for
# passing the sequence %rdi, %rsi, %rdx, %rcx, %r8 and %r9".
# `%rdi` = array pointer value, `%rcx` = array length value,
# `%rsi` = first value address, `%rdx` = it's index address,
# `%r8` = second value address, `%r9` = it's index address.
# 
# Expectations:
#
# (first_first_value, first_first_index) = (-10, 0),
# (first_second_value, first_second_index) = (-7, 8).
#
# (second_first_value, second_first_index) = (-11, 5),
# (second_second_value, second_second_index) = (-9, 1).

        # platform-specific for x86-64
        .set LLONG_MAX, 9223372036854775807
        .set LLONG_SIZE, 8

        .set DEFAULT_INDEX, -1

.section .rodata

        first_array_data: .8byte -10, 40, -2, 6, 80, -1, 3, 12, -7, 5
        first_array_info:
                first_array_size = first_array_info - first_array_data
                first_array_length = first_array_size / LLONG_SIZE - 1 # amortized for zero-based index

        second_array_data: .8byte 13, -9, 100, 31, -3, -11, 76
        second_array_info:
                second_array_size = second_array_info - second_array_data
                second_array_length = second_array_size / LLONG_SIZE - 1 # amortized for zero-based index

.section .data

        first_first_value: .8byte LLONG_MAX
        first_second_value: .8byte LLONG_MAX
        second_first_value: .8byte LLONG_MAX
        second_second_value: .8byte LLONG_MAX

        first_first_index: .8byte DEFAULT_INDEX
        first_second_index: .8byte DEFAULT_INDEX
        second_first_index: .8byte DEFAULT_INDEX
        second_second_index: .8byte DEFAULT_INDEX

.section .text

        .global _start

_start:
        movq   $first_array_data, %rdi     # store a pointer to an array
        movq   $first_array_length, %rcx   # load an array length
        movq   $first_first_value, %rsi    # copy initial value of first value
        movq   $first_first_index, %rdx    # copy initial value of first index
        movq   $first_second_value, %r8    # copy initial value of second value
        movq   $first_second_index, %r9    # copy initial value of second index
        callq  main
        movq   $second_array_data, %rdi    # store a pointer to an array
        movq   $second_array_length, %rcx  # load an array length
        movq   $second_first_value, %rsi   # copy initial value of first value
        movq   $second_first_index, %rdx   # copy initial value of first index
        movq   $second_second_value, %r8   # copy initial value of second value
        movq   $second_second_index, %r9   # copy initial value of second index
        callq  main
        jmp    exit

main:
        L_main_aux:
                movq  (%rdi, %rcx, LLONG_SIZE), %rax  # save `array[i]` into %rax
                cmpq  (%rsi), %rax                    # `array[i]` (from %rax) is less than first (from %r12)
                jle   L_main_first
                cmpq  (%r8), %rax                     # `array[i]` (from %rax) is less than second (from %r13)
                jl    L_main_second
                jmp   L_main_step

L_main_first:
        movq  (%rsi), %rbx  # copy previous first value into temp register
        movq  (%rdx), %r10  # copy previous first index into temp register
        movq  %rbx, (%r8)   # copy from temp register in second value
        movq  %r10, (%r9)   # copy from temp register in second index
        movq  %rax, (%rsi)  # store `array[i]` value as first value
        pushq %rcx          # store `i` as a new first index
        popq  (%rdx)        # load `i` as a new first index
        jmp   L_main_step

L_main_second:
        movq  (%r8), %rbx   # save current second value in temp register
        movq  (%r9), %r10   # save current second index in temp register
        movq  %rax, (%r8)   # store current array value as new second value
        movq  %rcx, (%r9)   # store current index as new second index
        jmp   L_main_step

L_main_step:
        decq  %rcx           # decrement loop counter value
        jge   L_main_aux
        retq

exit:
        movq     $60, %rax   # number 60 is a syscall for `exit`
        xorq     %rdi, %rdi  # make return code a `0` for success
        syscall
