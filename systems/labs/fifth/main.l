   1              	# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
   2              	#
   3              	# Task:
   4              	#
   5              	# Calculate the sums of all even (by index) elements from array with the
   6              	# odd elements (again, by index) from the same array and swap last element
   7              	# with the first element if the odds sum is greater than the evens one.
   8              	# Implement as a procedure compatible with `cdecl` calling convention.
   9              	#
  10              	# Expectations:
  11              	#
  12              	# (first_odd, first_even) = (25, -201),
  13              	# (second_odd, second_even) = (54, -39).
  14              	
  15              	        .set LLONG_SIZE, 8
  16              	
  17              	.section .data
  18              	
  19 0000 E9FFFFFF 	        first_array_data: .8byte -23, 38, -56, -79, 8, 91, -40, -86, -90, 61
  19      FFFFFFFF 
  19      26000000 
  19      00000000 
  19      C8FFFFFF 
  20              	        first_array_info:
  21              	                first_array_size = first_array_info - first_array_data
  22              	                first_array_length = first_array_size / LLONG_SIZE - 1 # amortized for zero-based i
  23              	
  24 0050 5D000000 	        second_array_data: .8byte 93, -17, -1, -9, 44, -46, 11
  24      00000000 
  24      EFFFFFFF 
  24      FFFFFFFF 
  24      FFFFFFFF 
  25              	        second_array_info:
  26              	                second_array_size = second_array_info - second_array_data
  27              	                second_array_length = second_array_size / LLONG_SIZE - 1 # amortized for zero-based
  28              	
  29              	.section .bss
  30              	
  31              	        .lcomm first_odd, 8
  32              	        .lcomm first_even, 8
  33              	
  34              	        .lcomm second_odd, 8
  35              	        .lcomm second_even, 8
  36              	
  37              	.section .text
  38              	
  39              	        .global _start
  40              	
  41              	_start:
  42 0000 68000000 	        pushq  $first_even           # store even value address
  42      00
  43 0005 68000000 	        pushq  $first_odd            # store odd value address
  43      00
  44 000a 68000000 	        pushq  $first_array_data     # store pointer to the array
  44      00
  45 000f 6A09     	        pushq  $first_array_length   # store array length value
  46 0011 E8180000 	        callq  main
  46      00
  47 0016 68000000 	        pushq  $second_even          # store even value address
  47      00
  48 001b 68000000 	        pushq  $second_odd           # store odd value address
  48      00
  49 0020 68000000 	        pushq  $second_array_data    # store pointer to the array
  49      00
  50 0025 6A06     	        pushq  $second_array_length  # store array length value
  51 0027 E8020000 	        callq  main
  51      00
  52 002c EB57     	        jmp    exit
  53              	
  54              	main:
  55              	        # prologue {
  56 002e 55       	        pushq  %rbp
  57 002f 4889E5   	        movq   %rsp, %rbp
  58              	        # } prologue
  59 0032 488B4D10 	        movq   16(%rbp), %rcx  # load array length value
  60 0036 4889CA   	        movq   %rcx, %rdx      # store array length for future
  61 0039 488B5D18 	        movq   24(%rbp), %rbx  # load array pointer
  62 003d 488B7520 	        movq   32(%rbp), %rsi  # load address of odd value
  63 0041 488B7D28 	        movq   40(%rbp), %rdi  # load address of even value
  64              	        L_main_aux:
  65 0045 488B04CB 	                movq   (%rbx, %rcx, LLONG_SIZE), %rax  # store `array[i]` into %rax
  66 0049 F6C101   	                testb  $1, %cl
  67 004c 7509     	                jnz    L_main_odd                      # `i` is odd
  68 004e 740C     	                jz     L_main_even                     # `i` is even
  69              	
  70              	L_main_step:
  71 0050 48FFC9   	        decq  %rcx         # decrement `i` loop counter
  72 0053 7DF0     	        jge   L_main_aux
  73 0055 EB0A     	        jmp   L_main_cond
  74              	
  75              	L_main_odd:
  76 0057 480106   	        addq  %rax, (%rsi)  # add `array[i]` to a sum of odds
  77 005a EBF4     	        jmp   L_main_step
  78              	
  79              	L_main_even:
  80 005c 480107   	        addq  %rax, (%rdi)  # add `array[i]` to a sum of evens
  81 005f EBEF     	        jmp   L_main_step
  82              	
  83              	L_main_cond:
  84 0061 488B06   	        movq  (%rsi), %rax  # load odd sum into %rax
  85 0064 482B07   	        subq  (%rdi), %rax  # compare odd sum from %rax with even
  86 0067 7F02     	        jg    L_main_swap
  87 0069 EB15     	        jmp   L_main_exit
  88              	
  89              	L_main_swap:
  90 006b 4C8D0CD3 	        leaq   (%rbx, %rdx, LLONG_SIZE), %r9  # store pointer to the last element
  91 006f 4C8D03   	        leaq   (%rbx), %r8                    # store pointer to the first element
  92 0072 41FF31   	        pushq  (%r9)                          # store temporary value of the first element
  93 0075 498B00   	        movq   (%r8), %rax                    # load first element into %rax by location
  94 0078 498901   	        movq   %rax, (%r9)                    # move first element from %rax to last element
  95 007b 418F00   	        popq   (%r8)                          # load first element as the last element
  96 007e EB00     	        jmp    L_main_exit
  97              	
  98              	L_main_exit:
  99              	        # epilogue {
 100 0080 4889EC   	        movq   %rbp, %rsp
 101 0083 5D       	        popq   %rbp
 102 0084 C3       	        retq
 103              	        # } epilogue
 104              	
 105              	exit:
 106 0085 48C7C03C 	        movq     $60, %rax   # number 60 is a syscall for `exit`
 106      000000
 107 008c 4831FF   	        xorq     %rdi, %rdi  # make return code a `0` for success
 108 008f 0F05     	        syscall              # call a syscall
