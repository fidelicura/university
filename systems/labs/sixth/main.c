/*
 * Made by Kirill Bezuglyi in GNU ASM with AT&T syntax for x86-64.
 *
 * Task:
 *
 * Sort an array in order of odd (by value) elements first, then
 * even (again, by value) ones, saving the initial order.
 * Determine amount and mean of non-negative numbers in an array.
 */


#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <sys/mman.h>

#define PRINT_ARRAY(text, arr) \
	printf("%s: ", text); \
	for (int i = 0; i < LEN; i++) { \
		printf("%d ", arr[i]); \
	} \
	printf("\n");
#define IS_ODD(num) (num & 1)
#define IS_EVEN(num) (!IS_ODD(num))

#define LEN (10)
#define LEN_AMORTIZED (LEN - 1)

int array[LEN] = { -23, 38, -56, -79, 8, 91, -40, -86, -90, 61 };

int 
main(void) {
	int mean = 0, amount = 0, temp;
	bool ok = false;

	PRINT_ARRAY("before", array);

	for (int i = LEN_AMORTIZED, elem = array[i]; i >= 0; i--, elem = array[i]) {
		if (elem > 0) {
			amount++;
			mean += elem;
		}

		if (IS_EVEN(elem)) {
			int j = i;
			while (j < LEN_AMORTIZED && IS_ODD(array[j+1])) {
				printf("%d swaps with %d\n", j, j+1);
				temp = array[j];
				array[j] = array[j+1];
				array[j+1] = temp;
				j++;
			}
		}
	}
	mean /= amount;

	PRINT_ARRAY("after", array);

	int expect[LEN] = { -23, -79, 91, 61, 38, -56, 8, -40, -86, -90 };
	for (int i = 0, elem = expect[i]; i < LEN; i++, elem = expect[i]) ok = true;
	printf("expected: %s\n", ok ? "OK" : "BAD");
	for (int i = 0; i < LEN; i++) if (array[i] != expect[i]) printf("index %d is not correct\n", i);

	printf("mean = %d, amount = %d\n", mean, amount);

	return 0;
}
