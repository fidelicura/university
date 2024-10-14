/*
 * Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
 *
 * Task:
 *
 * Find two smallest values and their indexes in array.
 */


#include <limits.h>
#include <stdio.h>

#define SIZE 10

const int array[SIZE] = { -10, 40, -2, 6, 80, -1, 3, 12, -7, 5 };

int 
main(void) {
	int first_val, second_val;
	int first_idx, second_idx;
	first_val = second_val = INT_MAX;
	first_idx = second_idx = -1;

	for (int i = 0; i < SIZE; i++) {
		if (array[i] < first_val) {
			// only if array size is 1, but we don't handle that
			// second_val = first_val;
			// second_idx = first_idx;

			first_val = array[i];
			first_idx = i;
		} else if (array[i] < second_val && array[i] != first_val) {
			second_val = array[i];
			second_idx = i;
		}
	}

	printf("first_val = %i, first_idx = %i\n", first_val, first_idx);
	printf("second_val = %i, second_idx = %i\n", second_val, second_idx);

	return 0;
}
