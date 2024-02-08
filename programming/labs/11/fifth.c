#include <stdio.h>
#include <math.h>

int main(void)
{
    int arr[] = { 27, 29, -34, 53, 73, 10, 16, -45, -97, 80 };
    int len = sizeof(arr) / sizeof(arr[0]);

    int min = arr[0];
    int min_idx = 0;
    int negative_count = 0;
    double geometric_mean = 1.0;

    for (int i = 0; i < len; ++i)
        if (arr[i] < min) {
            min = arr[i];
            min_idx = i;
        }

    for (int i = 0; i < len; ++i) {
        if (arr[i] < 0 && i < min_idx)
            negative_count++;

        if (i > min_idx && arr[i] > 0)
            geometric_mean *= arr[i];
    }

    geometric_mean = sqrt(geometric_mean);

    printf("Минимальный элемент: %d\n", min);
    printf("Позиция минимального элемента: %d\n", min_idx);
    printf("Количество отрицательных элементов перед минимальным: %d\n", negative_count);
    printf("Среднее геометрическое элементов после минимального: %lf\n", geometric_mean);
}
