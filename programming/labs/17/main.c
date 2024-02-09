#include <stdio.h>
#include <stdlib.h>

#define ARR_SIZE 6
#define DIGIT_AMOUNT 10

static const char* FILE_NAME = "input.data";

void findMinPositions(int *arr, int size, int *min, int *first_pos, int *last_pos) {
    *min = arr[0];
    *first_pos =  0;
    *last_pos =  0;

    for (int i =  1; i < size; i++) {
        if (arr[i] < *min) {
            *min = arr[i];
            *first_pos = i;
            *last_pos = i;
        } else if (arr[i] == *min) {
            *last_pos = i;
        }
    }
}

void countPositives(int *arr, int size, int first_pos, int last_pos, int *before, int *after) {
    *before =  0;
    *after =  0;

    for (int i =  0; i < first_pos; i++) {
        if (arr[i] >  0) {
            (*before)++;
        }
    }

    for (int i = last_pos +  1; i < size; i++) {
        if (arr[i] >  0) {
            (*after)++;
        }
    }
}

void sortBetweenMin(int *arr, int first_pos, int last_pos) {
    int start = first_pos + 1;
    int end = last_pos;

    while (start < end) {
        for (int i = start; i <= end; i++) {
            if (arr[i] > arr[i - 1]) {
                int temp = arr[i];
                arr[i] = arr[i - 1];
                arr[i - 1] = temp;
            }
        }
        end--;

        for (int i = end; i >= start; i--) {
            if (arr[i] < arr[i + 1]) {
                int temp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = temp;
            }
        }
        start++;
    }
}

int main(void) {
    FILE *file = fopen(FILE_NAME, "r");
    if (!file) {
        printf("Ошибка! Невозможно открыть указанный файл.");
        return EXIT_FAILURE;
    }

    int x[ARR_SIZE] = {4, 3, 10, 7, -3, 2};
    int *y = malloc(sizeof(int) * DIGIT_AMOUNT);
    int *z = calloc(DIGIT_AMOUNT, sizeof(int));

    for (int i =  0; i < DIGIT_AMOUNT; i++) {
        fscanf(file, "%d", &y[i]);
        fscanf(file, "%d", &z[i]);
    }

    fclose(file);

    int min, first_pos, last_pos, before, after;

    findMinPositions(x, ARR_SIZE, &min, &first_pos, &last_pos);
    countPositives(x, ARR_SIZE, first_pos, last_pos, &before, &after);
    sortBetweenMin(x, first_pos, last_pos);
    printf("Массив X:\n1) Минимальный элемент: %d\n2) Первый элемент: %d, последний элемент: %d\n3) Количество положительных до первого: %d\n4) Количество положительных за последним: %d\n\n", min, first_pos, last_pos, before, after);

    findMinPositions(y, DIGIT_AMOUNT, &min, &first_pos, &last_pos);
    countPositives(y, DIGIT_AMOUNT, first_pos, last_pos, &before, &after);
    sortBetweenMin(y, first_pos, last_pos);
    printf("Массив Y:\n1) Минимальный элемент: %d\n2) Первый элемент: %d, последний элемент: %d\n3) Количество положительных до первого: %d\n4) Количество положительных за последним: %d\n\n", min, first_pos, last_pos, before, after);

    findMinPositions(z, DIGIT_AMOUNT, &min, &first_pos, &last_pos);
    countPositives(z, DIGIT_AMOUNT, first_pos, last_pos, &before, &after);
    sortBetweenMin(z, first_pos, last_pos);
    printf("Массив Z:\n1) Минимальный элемент: %d\n2) Первый элемент: %d, последний элемент: %d\n3) Количество положительных до первого: %d\n4) Количество положительных за последним: %d\n", min, first_pos, last_pos, before, after);

    free(y);
    free(z);

    return EXIT_SUCCESS;
}
