#include <stdio.h>

#define MAX(X, Y) (((X) > (Y)) ? (X) : (Y))

int is_valid(const float a, const float b, const float c);

int main(void)
{
    float a, b, c, d;
    int count = 0;

    printf("Введите длину отрезка A: ");
    scanf("%f", &a);

    printf("Введите длину отрезка B: ");
    scanf("%f", &b);

    printf("Введите длину отрезка C: ");
    scanf("%f", &c);

    printf("Введите длину отрезка D: ");
    scanf("%f", &d);

    count += is_valid(a, b, c);
    count += is_valid(a, b, d);
    count += is_valid(b, c, d);

    char* word = "треугольника";
    if (count < 1 || count > 4) {
        word = "треугольников";
    }

    printf("Из отрезков A(%f), B(%f), C(%f), D(%f) можно составить %i %s.\n", a, b, c, d, count, word);
}

int is_valid(const float a, const float b, const float c)
{
    int half = (a + b + c) / 2;
    int max = MAX(a, MAX(b, c));

    return (half - max) >= 0 ? 1 : 0;
}
