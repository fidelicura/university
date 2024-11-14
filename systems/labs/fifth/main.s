# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
#
# Task:
#
# Calculate the sums of all even (by index) elements from array with the
# odd elements (again, by index) from the same array and swap last element
# with the first element if the odds sum is greater than the evens one.
# Implement as a procedure compatible with `cdecl` calling convention.
#
# Expectations:
#
# (first_odd, first_even) = (25, -201),
# (second_odd, second_even) = (54, -39).

        .set LLONG_SIZE, 8

.section .data

        first_array_data: .8byte -23, 38, -56, -79, 8, 91, -40, -86, -90, 61
        first_array_info:
                first_array_size = first_array_info - first_array_data
                first_array_length = first_array_size / LLONG_SIZE - 1 # amortized for zero-based index

        second_array_data: .8byte -93, 17, -1, -9, 44, 46, 11
        second_array_info:
                second_array_size = second_array_info - second_array_data
                second_array_length = second_array_size / LLONG_SIZE - 1 # amortized for zero-based index

.section .bss

        .lcomm first_odd, 8
        .lcomm first_even, 8

        .lcomm second_odd, 8
        .lcomm second_even, 8

.section .text

        .global _start

_start:
        pushq  $first_even           # store even value address
        pushq  $first_odd            # store odd value address
        pushq  $first_array_data     # store pointer to the array
        pushq  $first_array_length   # store array length value
        callq  main
        pushq  $second_even          # store even value address
        pushq  $second_odd           # store odd value address
        pushq  $second_array_data    # store pointer to the array
        pushq  $second_array_length  # store array length value
        callq  main
        jmp    exit

main:
        # prologue {
        pushq  %rbp
        movq   %rsp, %rbp
        # } prologue
        movq   16(%rbp), %rcx  # load array length value
        movq   %rcx, %rdx      # store array length for future
        movq   24(%rbp), %rbx  # load array pointer
        movq   32(%rbp), %rsi  # load address of odd value
        movq   40(%rbp), %rdi  # load address of even value
        L_main_aux:
                movq   (%rbx, %rcx, LLONG_SIZE), %rax  # store `array[i]` into %rax
                testb  $1, %cl
                jnz    L_main_odd                      # `i` is odd
                jz     L_main_even                     # `i` is even

L_main_step:
        decq  %rcx         # decrement `i` loop counter
        jge   L_main_aux
        jmp   L_main_cond

L_main_odd:
        addq  %rax, (%rsi)  # add `array[i]` to a sum of odds
        jmp   L_main_step

L_main_even:
        addq  %rax, (%rdi)  # add `array[i]` to a sum of evens
        jmp   L_main_step

L_main_cond:
        movq  (%rsi), %rax  # load odd sum into %rax
        subq  (%rdi), %rax  # compare odd sum from %rax with even
        jg    L_main_swap
        jmp   L_main_exit

L_main_swap:
        leaq   (%rbx, %rdx, LLONG_SIZE), %r9  # store pointer to the last element
        leaq   (%rbx), %r8                    # store pointer to the first element
        pushq  (%r9)                          # store temporary value of the first element
        movq   (%r8), %rax                    # load first element into %rax by location
        movq   %rax, (%r9)                    # move first element from %rax to last element
        popq   (%r8)                          # load first element as the last element
        jmp    L_main_exit

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
