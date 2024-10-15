   1              	# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64 Linux.
   2              	#
   3              	# Tasks:
   4              	#
   5              	# a = 11, b = 2, c = 21
   6              	# 
   7              	#      9 * 11 * 2 + 4 * 11 * 21
   8              	# x = ────────────────────────── = -51
   9              	#         2^2 - 2 * (11 + 2)
  10              	#
  11              	#          -51 * 21 - 2^2
  12              	# y = ────────────────────────── = 7
  13              	#      16 * (11 - 14) + 2 * -51
  14              	
  15              	.section .rodata
  16              	
  17 0000 72657375 	        msg: .asciz "result is -51 and 7\n"
  17      6C742069 
  17      73202D35 
  17      3120616E 
  17      6420370A 
  18              	        msg_len = . - msg
  19              	
  20 0015 0B000000 	        a: .8byte 11
  20      00000000 
  21 001d 02000000 	        b: .8byte 2
  21      00000000 
  22 0025 15000000 	        c: .8byte 21
  22      00000000 
  23              	
  24              	.section .bss
  25              	
  26              	        .lcomm x, 8
  27              	        .lcomm y, 8
  28              	
  29              	.section .text
  30              	
  31              	        .global _start
  32              	
  33              	_start:
  34              	        /* CALCULATION OF `x` */
  35              	
  36 0000 4C6B1425 	        imulq  $9, a, %r10    # 9 * 11 (from a) = 99, stored in %r10
  36      00000000 
  36      09
  37 0009 4C0FAF14 	        imulq  b, %r10        # 2 * 99 (from %r10) = 198, stored in %r10
  37      25000000 
  37      00
  38 0012 4C6B1C25 	        imulq  $4, a, %r11    # 4 * 11 (from a) = 44, stored in %r11
  38      00000000 
  38      04
  39 001b 4C0FAF1C 	        imulq  c, %r11        # 44 (from %r11) * 21 = 924, stored in %r11
  39      25000000 
  39      00
  40 0024 4D01DA   	        addq   %r11, %r10     # 198 + 924 = 1122, stored in %r10
  41 0027 4152     	        pushq  %r10           # save top expression result via pushing into stack
  42              	        
  43 0029 4C8B1425 	        movq   b, %r10        # move 2 from b into $r10 temp storage for further multiplication
  43      00000000 
  44 0031 4D0FAFD2 	        imulq  %r10, %r10     # 2 (from %r10) * 2 (from %r10) = 4, stored in %r10
  45 0035 4C8B1C25 	        movq   a, %r11        # move 11 from a into %r11 temp storage for further addition
  45      00000000 
  46 003d 4983C302 	        addq   $2, %r11       # 11 (from %r11) + 2 = 13, stored in %r11
  47 0041 4D6BDB02 	        imulq  $2, %r11       # 2 * 13 (from %r11) = 26, stored in %r11
  48 0045 4D29DA   	        subq   %r11, %r10     # 4 (from %r10) - 26 (from %r11) = -22, stored in %r10
  49 0048 58       	        popq   %rax           # restore result of top expression into %rbx
  50 0049 4899     	        cqto
  51 004b 49F7FA   	        idivq  %r10           # 1122 (from %rax) / -22 (from %r10) = -51.0, stored in %rax
  52 004e 48890425 	        movq   %rax, x        # save result into uninitialized variable
  52      00000000 
  53              	
  54              	        /* CALCULATION OF `y` */
  55              	
  56 0056 488B0425 	        movq   c, %rax        # move 21 (from c) into %rax temp storage for further multiplication
  56      00000000 
  57 005e 480FAF04 	        imulq  x, %rax        # -51 (from x) * 21 (from %rax) = -1071, stored in %rax
  57      25000000 
  57      00
  58 0067 488B3425 	        movq   b, %rsi        # move 2 (from b) into %rsi temp storage for further multiplication 
  58      00000000 
  59 006f 480FAFF6 	        imulq  %rsi, %rsi     # 2 (from %rsi) * 2 (from %rsi) = 4, stored in %rsi
  60 0073 4829F0   	        subq   %rsi, %rax     # -1071 (from %rax) - 4 (from %rsi) = -1075, stored in %rax
  61              	
  62 0076 488B3C25 	        movq   a, %rdi        # move 11 from a into %rdi for further subtraction
  62      00000000 
  63 007e 4883EF0E 	        subq   $14, %rdi      # 11 (from %rdi) - 14 = -3, stored in %rdi
  64 0082 486BFF10 	        imulq  $16, %rdi      # 16 * (-3) (from %rdi) = -48, stored in %rdi 
  65 0086 488B0C25 	        mov    x, %rcx        # move -51 from x into %rcx for further multiplication
  65      00000000 
  66 008e 486BC902 	        imulq  $2, %rcx       # 2 * (-51) (from %rcx) = -102, stored in %rcx
  67 0092 4801CF   	        addq   %rcx, %rdi     # -48 (from %rcx) + (-102) (from %rdi) = -150, stored in %rdi
  68              	
  69              	        /* RESULT CALCULATION */
  70              	
  71 0095 4899     	        cqto
  72 0097 48F7FF   	        idivq  %rdi           # -1075 (from %rax) / (-150) (from %rdi) = 7, stored in %rax
  73 009a 48890425 	        movq   %rax, y        # save result into uninitialized variable
  73      00000000 
  74              	        
  75              	        /* PROLOGUE JUMP */
  76              	
  77 00a2 EB00     	        jmp    print_message  # print the predefined message for the user
  78              	
  79              	print_message:
  80 00a4 48C7C001 	        movq     $1, %rax        # number 1 is a syscall for `write`
  80      000000
  81 00ab 48C7C701 	        movq     $1, %rdi        # number 1 is a fd for `stdout`
  81      000000
  82 00b2 48C7C600 	        movq     $msg, %rsi      # address of the message
  82      000000
  83 00b9 48C7C215 	        movq     $msg_len, %rdx  # message length
  83      000000
  84 00c0 0F05     	        syscall                  # call a syscall
  85 00c2 EB00     	        jmp       exit           # exit at the end of the program
  86              	
  87              	exit:
  88 00c4 48C7C03C 	        movq     $60, %rax   # number 60 is a syscall for `exit`
  88      000000
  89 00cb 4831FF   	        xorq     %rdi, %rdi  # make return code a `0` for success
  90 00ce 0F05     	        syscall              # call a syscall
