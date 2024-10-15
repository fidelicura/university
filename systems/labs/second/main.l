   1              	# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
   2              	#
   3              	# Tasks:
   4              	#
   5              	#     ( a + b,   if a / b < 0
   6              	# y = < a * b^2, if a / b = 0
   7              	#     ( 10 + b,  if a / b > 0
   8              	
   9              	.section .bss
  10              	
  11              	        .lcomm a, 8
  12              	        .lcomm b, 8
  13              	        .lcomm y, 8
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
  27 0002 C7042500 	        movl   $0x0AF3B2AA, a    # set lower half of a
  27      000000AA 
  27      B2F30A
  28 000d C7042500 	        movl   $0x3CDB2CAD, a+4  # set upper half of a
  28      000000AD 
  28      2CDB3C
  29              	        # a = 4385147783900017322
  30 0018 C7042500 	        movl   $0x00000000, b    # set lower half of b
  30      00000000 
  30      000000
  31 0023 C7042500 	        movl   $0xE0000000, b+4  # set upper half of b
  31      00000000 
  31      0000E0
  32              	        # b = -2305843009213693952
  33 002e 488B0425 	        movq   a, %rax           # %rax = a
  33      00000000 
  34 0036 488B1C25 	        movq   b, %rbx           # %rbx = b
  34      00000000 
  35 003e 4899     	        cqto
  36 0040 48F7FB   	        idivq  %rbx              # a (from %rax) / b (from %rbx) = result, stored in %rax
  37 0043 4885C0   	        testq  %rax, %rax        # check if result (from %rax) is zero via logical and
  38 0046 0F8C8C00 	        jl     lesser
  38      0000
  39              	
  40              	second:
  41 004c C7042500 	        movl   $0x00000000, a    # set lower half of a
  41      00000000 
  41      000000
  42 0057 C7042500 	        movl   $0x00000000, a+4  # set upper half of a
  42      00000000 
  42      000000
  43              	        # a = 0
  44 0062 C7042500 	        movl   $0xEE538000, b    # set lower half of b
  44      00000000 
  44      8053EE
  45 006d C7042500 	        movl   $0x200AA87B, b+4  # set upper half of b
  45      0000007B 
  45      A80A20
  46              	        # b = 2308843009213693952
  47 0078 488B0425 	        movq   a, %rax           # %rax = a
  47      00000000 
  48 0080 488B1C25 	        movq   b, %rbx           # %rbx = b
  48      00000000 
  49 0088 4899     	        cqto
  50 008a 48F7FB   	        idivq  %rbx              # a (from %rax) / b (from %rbx) = result, stored in %rax
  51 008d 4885C0   	        testq  %rax, %rax        # check if result (from %rax) is zero via logical and
  52 0090 745B     	        je     equal
  53              	
  54              	third:
  55 0092 C7042500 	        movl   $0x0AF3B2AA, a    # set lower half of a
  55      000000AA 
  55      B2F30A
  56 009d C7042500 	        movl   $0x3CDB2CAD, a+4  # set upper half of a
  56      000000AD 
  56      2CDB3C
  57              	        # a = 4385147783900017322
  58 00a8 C7042500 	        movl   $0xFBDE6000, b    # set lower half of b
  58      00000000 
  58      60DEFB
  59 00b3 C7042500 	        movl   $0x20000574, b+4  # set upper half of b
  59      00000074 
  59      050020
  60              	        # b = 2305849009213693952
  61 00be 488B0425 	        movq   a, %rax           # %rax = a
  61      00000000 
  62 00c6 488B1C25 	        movq   b, %rbx           # %rbx = b
  62      00000000 
  63 00ce 4899     	        cqto
  64 00d0 48F7FB   	        idivq  %rbx              # %rax (a) / %rbx (b) = result, stored in %rax
  65 00d3 4885C0   	        testq  %rax, %rax        # check if result (from %rax) is zero via logical and
  66 00d6 7F27     	        jg     greater
  67              	
  68              	/* COMPARE LABELS */
  69              	
  70              	lesser:
  71 00d8 48031C25 	        addq  a, %rbx  # a + value from %rbx = result, stored in %rbx
  71      00000000 
  72 00e0 48891C25 	        movq  %rbx, y  # y = 2079304774686323370
  72      00000000 
  73 00e8 E95FFFFF 	        jmp   second
  73      FF
  74              	
  75              	equal:
  76 00ed 480FAFDB 	        imulq  %rbx, %rbx  # %rbx^2 = result, stored in %rbx
  77 00f1 480FAFD8 	        imulq  %rax, %rbx  # value from %rax * value from %rbx = result, stored in %rbx
  78 00f5 48891C25 	        movq   %rbx, y     # y = 0
  78      00000000 
  79 00fd EB93     	        jmp    third
  80              	
  81              	greater:
  82 00ff 4883C30A 	        addq  $10, %rbx  # 10 + value from %rbx = result, stored in %rbx
  83 0103 48891C25 	        movq  %rbx, y    # y = 2305849009213693962
  83      00000000 
  84 010b EB00     	        jmp   exit
  85              	
  86              	/* PROLOGUE JUMP */
  87              	
  88              	exit:
  89 010d 48C7C03C 	        movq     $60, %rax   # number 60 is a syscall for `exit`
  89      000000
  90 0114 4831FF   	        xorq     %rdi, %rdi  # make return code a `0` for success
  91 0117 0F05     	        syscall
