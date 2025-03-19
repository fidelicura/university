#include <stdio.h>
#include <math.h>

double Fx(double x)
{
	return -0.6768 + 0.144 * x + 0.47 * x * x - 0.1 * x * x * x;
}
double fx(double x)
{
	return  x - 0.6768 + 0.144 * x + 0.47 * x * x - 0.1 * x * x * x;
}
double f_x(double x)
{
	return 1 + 0.144 + 2 * 0.47 * x - 3 * 0.1 * x * x;
}

int main(void)
{
	double j, x1, x2, masx[3] = { 0 }, step = 1, E = 0.0001;
	int k = 0, n = 0;
	for (j = -5; j <= 4; j += step)
		if (n <= 2 && ((Fx(j) > 0 && Fx(j + step) < 0) || (Fx(j) < 0 && Fx(j + step) > 0)))
		{
			masx[n] = (2 * j + step) / 2;
			n++;
		}
	if (n <= 2)
	{
		printf("Программа не может продолжать работу дальше, т.к. нет нужного корня.");
		return -1;
	}
	printf("\nМетод последовательных приближений\n\n\n");
	printf("Поиск корней с шагом: %.4f\n\n", step);
	printf("-----------------------------------------\n");
	printf("|    x1     |      x2      |    x3      |\n");
	printf("-----------------------------------------\n");
	printf("|  %.4f  |  %.4f    |  %.4f    |\n", masx[0], masx[1], masx[2]);
	printf("-----------------------------------------\n\n");
	printf("Результаты для корня 2  x0=%.1f\n\n", masx[1]);
	printf("-----------------------------------------\n");
	printf("| № |    xi    |   xi+1   | abs(xi+1-xi)|\n");
	printf("-----------------------------------------\n");
	x1 = masx[1]; x2 = fx(x1); n = 1;
	printf("|%2d.| %.5f |  %.5f  |  %.5f  |\n", n, x1, x2, fabs(x2 - x1));
	while (fabs(x2 - x1) >= E)
	{
		x1 = x2; x2 = fx(x1);
		if (fabs(f_x(x2)) > 1)
		{
			printf("\nМетод раходится.\n\n");
			k = 1;
			break;
		}
		printf("|%2d.| %.5f |  %.5f  |  %.5f  |\n", n++, x1, x2, fabs(x2 - x1));
	}
	if (k == 0)
		printf("-----------------------------------------\n");

	return 0;
}
