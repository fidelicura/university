#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define FROM (-5)
#define UPTO  (4)

#define STEP (1.)

// #define A (0.6768)
// #define B (-0.144)
// #define C (-0.47)
// #define D (0.1)
// #define E (0.0001)

#define A (-0.6768)
#define B (0.144)
#define C (0.47)
#define D (-0.1)
#define E (0.0001)
 
#define NEWLINE() do { \
		printf("\n"); \
	} while (0)

double
initial_f(double x)
{
	return (A) + (B * x) + (C * x * x) + (D * x * x * x);
}

double
iterative_f(double x)
{
	return x - (A) + (B * x) + (C * x * x) + (D * x * x * x);
}

double
derivative_f(double x)
{
	return 1 + (B) + (2 * C * x) - (3 * D * x * x);
}

void
root_approximations(double *x1, double *x2, double *roots, int *root_count)
{
	int iteration = 0;

	for (int i = FROM; i <= UPTO; i += STEP) {
	        if (*root_count <= 2 && ((initial_f(i) > 0 && initial_f(i + STEP) < 0) ||
	                                (initial_f(i) < 0 && initial_f(i + STEP) > 0))) {
			roots[*root_count] = (2 * i + STEP) / 2;
			(*root_count)++;
	        }
	}


	*x1 = roots[1];
	*x2 = iterative_f(*x1);
}

void
check_rootability(int *n)
{
	if (*n <= 2) {
		printf("Нужный корень не был обнаружен. Работа программы была завершена.\n");
		exit(EXIT_FAILURE);
	};
	*n = 1;
}

void
print_interface(double *roots, int iter, double x1, double x2)
{
	bool convergence = false;

	printf("|----------------------------------|\n");
	printf("|              КОРНИ               |\n");
	printf("|----------------------------------|\n");
	printf("|     1     |     2     |     3    |\n");
	printf("|----------------------------------|\n");
	printf("| %.6f | %.7f | %.6f |\n", roots[0], roots[1], roots[2]);
	printf("|----------------------------------|\n");
	printf("|            РЕЗУЛЬТАТ             |\n");
	printf("|----------------------------------|\n");
	printf("| N# |    Т    |    С    |   ABS   |\n");
	printf("|----------------------------------|\n");
	printf("| %02d | %.5f | %.5f | %.5f |\n", iter, x1, x2, fabs(x2 - x1));
	while (fabs(x2 - x1) >= E)
	{
		x1 = x2;
		x2 = iterative_f(x1);

		if (fabs(derivative_f(x2)) > 1)
		{
			NEWLINE();
			printf("Метод расходится.\n");
			break;
		}
		printf("| %02d | %.5f | %.5f | %.5f |\n", iter++, x1, x2, fabs(x2 - x1));
	}
}

int
main(void)
{
	double x1, x2, roots[3] = { 0 };
	int k = 0, n = 0;

	root_approximations(&x1, &x2, roots, &n);
	check_rootability(&n);
	print_interface(roots, n, x1, x2);

	return EXIT_SUCCESS;
}
