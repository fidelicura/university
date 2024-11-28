define print_arrays
	set $first_array = (long long *)&first_array_data
	set $first_len = 10
	print *$first_array@$first_len

	set $second_array = (long long *)&second_array_data
	set $second_len = 7
	print *$second_array@$second_len
end
