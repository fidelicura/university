   1              	# Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64 Linux.
   2              	#
   3              	# Task:
   4              	#
   5              	# Find two smallest values and their indexes in array.
   6              	
   7              	.section .rodata
   8              	
   9              	        # platform-specific for x86-64
  10              	        .set LLONG_MAX, 9223372036854775807
  11              	        .set LLONG_SIZE, 8
  12              	
  13              	        .set DEFAULT_IDX, -1
  14              	
  15 0000 F6FFFFFF 	        array_data: .8byte -10, 40, -2, 6, 80, -1, 3, 12, -7, 5
  15      FFFFFFFF 
  15      28000000 
  15      00000000 
  15      FEFFFFFF 
  16              	        array_info:
  17              	                array_size = array_info - array_data
  18              	                array_length = array_size / 8 - 1 # amortized for zero-based index
  19              	
  20              	.section .data
  21              	
  22 0000 FFFFFFFF 	        first_val: .8byte LLONG_MAX
  22      FFFFFF7F 
  23 0008 FFFFFFFF 	        second_val: .8byte LLONG_MAX
  23      FFFFFF7F 
  24              	
  25 0010 FFFFFFFF 	        first_idx: .8byte DEFAULT_IDX
  25      FFFFFFFF 
  26 0018 FFFFFFFF 	        second_idx: .8byte DEFAULT_IDX
  26      FFFFFFFF 
  27              	
  28              	.section .text
  29              	
  30              	        .global _start
  31              	
  32              	_start:
  33 0000 48C7C109 	        movq  $array_length, %rcx  # store a length as a counter for a loop
  33      000000
  34              	        L_aux:
  35 0007 486314CD 	                movslq array_data(, %rcx, LLONG_SIZE), %rdx  # save array[i] into %rdx
  35      00000000 
  36 000f 483B1425 	                cmpq first_val, %rdx                       # array[i] (from %rdx) is less than firs
  36      00000000 
  37 0017 7E0C     	                jle L_first
  38 0019 483B1425 	                cmpq second_val, %rdx                      # array[i] (from %rdx) is less than seco
  38      00000000 
  39 0021 7C34     	                jl L_second
  40 0023 EB44     	                jmp L_step
  41              	
  42              	L_first:
  43 0025 488B0425 	        movq  first_val, %rax        # copy previous first value into temp register
  43      00000000 
  44 002d 488B1C25 	        movq  first_idx, %rbx        # copy previous first index into temp register
  44      00000000 
  45 0035 48890425 	        movq  %rax, second_val       # copy from temp register in second value
  45      00000000 
  46 003d 48891C25 	        movq  %rbx, second_idx       # copy from temp register in second index
  46      00000000 
  47 0045 48891425 	        movq  %rdx, first_val        # store array[i] value as first value
  47      00000000 
  48 004d 48890C25 	        movq  %rcx, first_idx        # store i index as first index
  48      00000000 
  49 0055 EB12     	        jmp   L_step
  50              	
  51              	L_second:
  52 0057 48891425 	        movq  %rdx, second_val  # otherwise, store array[i] value as first value
  52      00000000 
  53 005f 48890C25 	        movq  %rcx, second_idx  # and store i index as first index
  53      00000000 
  54 0067 EB00     	        jmp   L_step
  55              	
  56              	L_step:
  57 0069 48FFC9   	        decq  %rcx    # decrement loop counter value
  58 006c 7D99     	        jge   L_aux
  59 006e EB00     	        jmp   exit
  60              	
  61              	exit:
  62 0070 48C7C03C 	        movq     $60, %rax   # number 60 is a syscall for `exit`
  62      000000
  63 0077 4831FF   	        xorq     %rdi, %rdi  # make return code a `0` for success
  64 007a 0F05     	        syscall
