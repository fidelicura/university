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

	if (array[SIZE - 1] < array[SIZE - 2]) {
		first_val = array[SIZE - 1];
		second_val = array[SIZE - 2];

		first_idx = SIZE - 1;
		second_idx = SIZE - 2;
	} else {
		first_val = array[SIZE - 2];
		second_val = array[SIZE - 1];

		first_idx = SIZE - 2;
		second_idx = SIZE - 1;
	}

	for (int i = SIZE - 3; i >= 0; i--) {
		if (array[i] <= first_val) {
			second_val = first_val;
			second_idx = first_idx;
			first_val = array[i];
			first_idx = i;
		} else if (array[i] < second_val) {
			second_val = array[i];
			second_idx = i;
		}
	}

	printf("first_val = %i, first_idx = %i\n", first_val, first_idx);
	printf("second_val = %i, second_idx = %i\n", second_val, second_idx);

	return 0;
}
