#include <stdio.h>

void sort(int* a, int* b, int* c, int* d);
void swap(int* first, int* second);

int main(void)
{
    int a, b, c, d;

    printf("Введите значение переменной A: ");
    scanf("%i", &a);
    
    printf("Введите значение переменной B: ");
    scanf("%i", &b);
    
    printf("Введите значение переменной C: ");
    scanf("%i", &c);
    
    printf("Введите значение переменной D: ");
    scanf("%i", &d);

    printf("\nБыло: [%i, %i, %i, %i]", a, b, c, d);
    sort(&a, &b, &c, &d);
    printf("\nСтало: [%i, %i, %i, %i]", a, b, c, d);
}

void sort(int* a, int* b, int* c, int* d)
{
    int i = 0;

    while (i < 8) {
        if (*a < *b)
            swap(a, b);

        if (*a < *c)
            swap(a, c);
    
        if (*a < *d)
            swap(a, d);
    
        if (*b < *c)
            swap(b, c);
    
        if (*b < *d)
            swap(b, d);
    
        if (*c < *d)
            swap(c, d);

        ++i;
    }
}

void swap(int* first, int* second)
{
    int temp = *first;
    *first = *second;
    *second = temp;
}
