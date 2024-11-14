define print_block
    set $block = (long long*)&$arg0
    
    printf "amount = %lld\n", *$block
    printf "mean = %f\n", *(double*)($block + 1)

    set $array_length = *($block + 2)
    printf "length = %lld\n", $array_length
    set $array_ptr = (long long*)*($block + 3)

    set $i = 0
    while $i < ($array_length + 1)
        printf "elem[%d] = %lld\n", $i, $array_ptr[$i]
        set $i = $i + 1
    end
end
