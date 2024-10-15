# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
#
# Tasks:
#
#     ( a + b,   if a / b < 0
# y = < a * b^2, if a / b = 0
#     ( 10 + b,  if a / b > 0

.section .bss

        .lcomm a, 8
        .lcomm b, 8
        .lcomm y, 8

.section .text

        .global _start

/* EPILOGUE */

_start:
        jmp first

/* CONDITION LABELS */

first:
        movl   $0x0AF3B2AA, a    # set lower half of a
        movl   $0x3CDB2CAD, a+4  # set upper half of a
        # a = 4385147783900017322
        movl   $0x00000000, b    # set lower half of b
        movl   $0xE0000000, b+4  # set upper half of b
        # b = -2305843009213693952
        movq   a, %rax           # %rax = a
        movq   b, %rbx           # %rbx = b
        cqto
        idivq  %rbx              # a (from %rax) / b (from %rbx) = result, stored in %rax
        testq  %rax, %rax        # check if result (from %rax) is zero via logical and
        jl     lesser

second:
        movl   $0x00000000, a    # set lower half of a
        movl   $0x00000000, a+4  # set upper half of a
        # a = 0
        movl   $0xEE538000, b    # set lower half of b
        movl   $0x200AA87B, b+4  # set upper half of b
        # b = 2308843009213693952
        movq   a, %rax           # %rax = a
        movq   b, %rbx           # %rbx = b
        cqto
        idivq  %rbx              # a (from %rax) / b (from %rbx) = result, stored in %rax
        testq  %rax, %rax        # check if result (from %rax) is zero via logical and
        je     equal

third:
        movl   $0x0AF3B2AA, a    # set lower half of a
        movl   $0x3CDB2CAD, a+4  # set upper half of a
        # a = 4385147783900017322
        movl   $0xFBDE6000, b    # set lower half of b
        movl   $0x20000574, b+4  # set upper half of b
        # b = 2305849009213693952
        movq   a, %rax           # %rax = a
        movq   b, %rbx           # %rbx = b
        cqto
        idivq  %rbx              # %rax (a) / %rbx (b) = result, stored in %rax
        testq  %rax, %rax        # check if result (from %rax) is zero via logical and
        jg     greater

/* COMPARE LABELS */

lesser:
        addq  a, %rbx  # a + value from %rbx = result, stored in %rbx
        movq  %rbx, y  # y = 2079304774686323370
        jmp   second

equal:
        imulq  %rbx, %rbx  # %rbx^2 = result, stored in %rbx
        imulq  %rax, %rbx  # value from %rax * value from %rbx = result, stored in %rbx
        movq   %rbx, y     # y = 0
        jmp    third

greater:
        addq  $10, %rbx  # 10 + value from %rbx = result, stored in %rbx
        movq  %rbx, y    # y = 2305849009213693962
        jmp   exit

/* PROLOGUE JUMP */

exit:
        movq     $60, %rax   # number 60 is a syscall for `exit`
        xorq     %rdi, %rdi  # make return code a `0` for success
        syscall
