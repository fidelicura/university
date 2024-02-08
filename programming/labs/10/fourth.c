#include <stdio.h>

int main(void)
{
    int a, b;
    int count = 0;

    printf("Введите целое десятичное число: ");
    scanf("%i", &a);

    b = a;

    while (a != 0) {
        int digit = a % 10;
        if (digit % 2 == 0)
            count++;

        a /= 10;
    }

    printf("Количество четных цифр в числе %i - %i", b, count);
}
