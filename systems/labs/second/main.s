# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64 Linux.
#
# Tasks:
#
#     ( a + b,   if a / b < 0
# y = < a * b^2, if a / b = 0
#     ( 10 + b,  if a / b > 0

.section .bss

        .lcomm a, 1
        .lcomm b, 1
        .lcomm y, 1

.section .text

        .global _start

/* EPILOGUE */

_start:
        jmp first

/* CONDITION LABELS */

first:
        movb   $4, a     # set a equal to 4
        movb   $-2, b    # set b equal to -2
        movb   a, %al    # al = a
        movb   b, %bl    # bl = b
        cbw
        idivb  %bl       # a (from %ax) / b (from %bl) = result, stored in %al
        testb  %al, %al  # check if result (from %al) is zero via logical and
        jl     lesser

second:
        movb   $0, a     # set a equal to 0
        movb   $7, b     # set b equal to 7
        movb   a, %al    # al = a
        movb   b, %bl    # bl = b
        cbw
        idivb  %bl       # a (from %ax) / b (from %bl) = result, stored in %al
        testb  %al, %al  # check if result (from %al) is zero via logical and
        je     equal

third:
        movb   $8, a     # set a equal to 8
        movb   $4, b     # set b equal to 4
        movb   a, %al    # al = a
        movb   b, %bl    # bl = b
        cbw
        idivb  %bl       # a (from %ax) / b (from %bl) = result, stored in %al
        testb  %al, %al  # check if result (from %al) is zero via logical and
        jg     greater

/* COMPARE LABELS */

lesser:
        addb  a, %bl  # a + %bl = result, stored in %bl
        movb  %bl, y  # y = %bl
        jmp   second

equal:
        imulw  %bx, %bx  # %bl^2 = result, stored in %bl
        imulw  %ax, %bx  # value from %al * value from %bl = result, stored in %bl
        movw   %bx, y    # y = %bl
        jmp    third

greater:
        addb  $10, %bl  # 10 + value from %rbx = result, stored in %rbx
        movb  %bl, y    # y = %bl
        jmp   exit

/* PROLOGUE JUMP */

exit:
        movq     $60, %rax   # number 60 is a syscall for `exit`
        xorq     %rdi, %rdi  # make return code a `0` for success
        syscall
