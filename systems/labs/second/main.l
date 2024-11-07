   1              	# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64 Linux.
   2              	#
   3              	# Tasks:
   4              	#
   5              	#     ( a + b,   if a / b < 0
   6              	# y = < a * b^2, if a / b = 0
   7              	#     ( 10 + b,  if a / b > 0
   8              	
   9              	.section .bss
  10              	
  11              	        .lcomm a, 1
  12              	        .lcomm b, 1
  13              	        .lcomm y, 1
  14              	
  15              	.section .text
  16              	
  17              	        .global _start
  18              	
  19              	/* EPILOGUE */
  20              	
  21              	_start:
  22 0000 EB00     	        jmp first
  23              	
  24              	/* CONDITION LABELS */
  25              	
  26              	first:
  27 0002 C6042500 	        movb   $4, a     # set a equal to 4
  27      00000004 
  28 000a C6042500 	        movb   $-2, b    # set b equal to -2
  28      000000FE 
  29 0012 8A042500 	        movb   a, %al    # al = a
  29      000000
  30 0019 8A1C2500 	        movb   b, %bl    # bl = b
  30      000000
  31 0020 6698     	        cbw
  32 0022 F6FB     	        idivb  %bl       # a (from %ax) / b (from %bl) = result, stored in %al
  33 0024 84C0     	        testb  %al, %al  # check if result (from %al) is zero via logical and
  34 0026 7C4C     	        jl     lesser
  35              	
  36              	second:
  37 0028 C6042500 	        movb   $0, a     # set a equal to 0
  37      00000000 
  38 0030 C6042500 	        movb   $7, b     # set b equal to 7
  38      00000007 
  39 0038 8A042500 	        movb   a, %al    # al = a
  39      000000
  40 003f 8A1C2500 	        movb   b, %bl    # bl = b
  40      000000
  41 0046 6698     	        cbw
  42 0048 F6FB     	        idivb  %bl       # a (from %ax) / b (from %bl) = result, stored in %al
  43 004a 84C0     	        testb  %al, %al  # check if result (from %al) is zero via logical and
  44 004c 7436     	        je     equal
  45              	
  46              	third:
  47 004e C6042500 	        movb   $8, a     # set a equal to 8
  47      00000008 
  48 0056 C6042500 	        movb   $4, b     # set b equal to 4
  48      00000004 
  49 005e 8A042500 	        movb   a, %al    # al = a
  49      000000
  50 0065 8A1C2500 	        movb   b, %bl    # bl = b
  50      000000
  51 006c 6698     	        cbw
  52 006e F6FB     	        idivb  %bl       # a (from %ax) / b (from %bl) = result, stored in %al
  53 0070 84C0     	        testb  %al, %al  # check if result (from %al) is zero via logical and
  54 0072 7F22     	        jg     greater
  55              	
  56              	/* COMPARE LABELS */
  57              	
  58              	lesser:
  59 0074 021C2500 	        addb  a, %bl  # a + %bl = result, stored in %bl
  59      000000
  60 007b 881C2500 	        movb  %bl, y  # y = %bl
  60      000000
  61 0082 EBA4     	        jmp   second
  62              	
  63              	equal:
  64 0084 660FAFDB 	        imulw  %bx, %bx  # %bl^2 = result, stored in %bl
  65 0088 660FAFD8 	        imulw  %ax, %bx  # value from %al * value from %bl = result, stored in %bl
  66 008c 66891C25 	        movw   %bx, y    # y = %bl
  66      00000000 
  67 0094 EBB8     	        jmp    third
  68              	
  69              	greater:
  70 0096 80C30A   	        addb  $10, %bl  # 10 + value from %rbx = result, stored in %rbx
  71 0099 881C2500 	        movb  %bl, y    # y = %bl
  71      000000
  72 00a0 EB00     	        jmp   exit
  73              	
  74              	/* PROLOGUE JUMP */
  75              	
  76              	exit:
  77 00a2 48C7C03C 	        movq     $60, %rax   # number 60 is a syscall for `exit`
  77      000000
  78 00a9 4831FF   	        xorq     %rdi, %rdi  # make return code a `0` for success
  79 00ac 0F05     	        syscall
