# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
#
# Task:
#
# Calculate the sums of all even elements from the first array with the
# odd elements from the second array and swap last elements from both
# arrays with each other if the first sum is greater than the second one.
# Implement as a procedure compatible with `cdecl` calling convention.

        .set LLONG_SIZE, 8

.section .data

        array_data: .8byte -23, 38, -56, -79, 8, 91, -40, -86, -90, 61
        array_info:
                array_size = array_info - array_data
                array_length = array_size / LLONG_SIZE - 1 # amortized for zero-based index

        # array_data: .8byte -93, 17, -1, -9, 44, 46, 11
        # array_info:
        #         array_size = array_info - array_data
        #         array_length = array_size / 8 - 1 # amortized for zero-based index

.section .bss

        .lcomm odd, 8
        .lcomm even, 8

.section .text
.code64

        .global _start

_start:
        pushq  $array_data     # store pointer to the array
        pushq  $array_length   # store array length value
        callq  main
        jmp    exit

main:
        # prologue {
        pushq  %rbp
        movq   %rsp, %rbp
        # } prologue
        movq   16(%rbp), %rcx  # load odd array length 
        movq   24(%rbp), %rbx  # load odd array data
        movq   %rcx, %rsi      # store length further
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
        addq  %rax, odd    # add `array[i]` to a sum of odds
        jmp   L_main_step

L_main_even:
        addq  %rax, even   # add `array[i]` to a sum of evens
        jmp   L_main_step

L_main_cond:
        movq  odd, %rax    # load odd sum into %rax
        subq  even, %rax   # compare odd sum from %rax with even
        jg    L_main_swap
        jmp   L_main_exit

L_main_swap:
        leaq   (%rbx, %rsi, LLONG_SIZE), %r9  # store pointer to the last element
        leaq   (%rbx), %r8                      # store pointer to the first element
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
