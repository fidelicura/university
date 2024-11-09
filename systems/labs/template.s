# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
#
# Task:
#
# ...

.section .text

        .global _start

_start:
        jmp exit

exit:
        movq     $60, %rax   # number for `exit`
        xorq     %rdi, %rdi  # success return code
        syscall
