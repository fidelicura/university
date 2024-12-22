# define print_block
#     set $block = (long long*)&$arg0
    
#     printf "amount = %lld\n", *$block
#     printf "mean = %f\n", *(double*)($block + 1)

#     set $array_length = *($block + 2)
#     printf "length = %lld\n", $array_length
#     set $array_ptr = (long long*)*($block + 3)

#     set $i = 0
#     while $i < ($array_length + 1)
#         printf "elem[%d] = %lld\n", $i, $array_ptr[$i]
#         set $i = $i + 1
#     end
# end

define printer
    printf "\n#1\narray: "
    print *((long long *)&first_array_data)@10
    printf "mean = %lld\namount = %lld\n\n", (long long)first_mean, (long long)first_amount

    printf "#2\narray: "
    print *((long long *)&second_array_data)@10
    printf "mean = %lld\namount = %lld\n\n", (long long)second_mean, (long long)second_amount
end
