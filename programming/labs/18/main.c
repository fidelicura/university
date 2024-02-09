#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void zeroOddIndexed(double *row, int length) {
    for (int i = 1; i < length; i += 2) {
        row[i] = 0.0;
    }
}

int findRowWithMinimumZeroes(double (*matrix)[10], int rows) {
    int min_zero_count = 10;
    int min_zero_idx = 0;

    for (int i = 0; i < rows; i++) {
        int zeroes_counter = 0;
        for (int j = 0; j < 10; j++) {
            if (matrix[i][j] == 0.0) {
                zeroes_counter++;
            }
        }
        if (zeroes_counter < min_zero_count) {
            min_zero_count = zeroes_counter;
            min_zero_idx = i;
        }
    }
    return min_zero_idx;
}

int main(void) {
    double a[10][10];
    double (*b)[10] = a;
    int rows = 10;

    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < 10; j++) {
            a[i][j] = (i + j) % 2 == 0 ? (i + j) / 2.0 : (i + j) / 1.0;
        }
    }

    b = malloc(sizeof(*b) * rows);
    if (b == NULL) {
        printf("Ошибка! Невозможно выделить больше памяти на куче.");
        return EXIT_FAILURE;
    }
    
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < 10; j++) {
            b[i][j] = a[i][j];
        }
    }

    for (int i = 0; i < rows; i++) {
        zeroOddIndexed((double *)a[i], 10);
    }

    for (int i = 0; i < rows; i++) {
        zeroOddIndexed(b[i], 10);
    }

    int rowIndexA = findRowWithMinimumZeroes(a, rows);
    printf("Линии с минимальным количеством нулей в матрице A: %d\n", rowIndexA);

    int rowIndexB = findRowWithMinimumZeroes(b, rows);
    printf("Линии с минимальным количеством нулей в матрице B: %d\n", rowIndexB);

    if (rowIndexA == rowIndexB) {
        printf("Результаты не отличаются.\n");
    } else {
        printf("Результаты отличаются.\n");
    }

    free(b);

    return 0;
}
