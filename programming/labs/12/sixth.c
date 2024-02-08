#include <stdio.h>

#define ROWS 3
#define COLS 4

int main(void)
{
    int matrix[ROWS][COLS] = {
        { 35, 30, 96, 69 },
        { 16, 27, 68, 97 },
        { 66, 37, 7, 89 },
    };

    int idx_zeroes = 0;
    int row_min_zeroes = 0;
    for (int i = 0; i < ROWS; ++i) {
        int row_zeroes = 0;
        for (int j = 0; j < COLS; ++j)
            if (j % 2 != 0) {
                row_zeroes++;
                matrix[i][j] = 0;
            }

        if (row_zeroes < row_min_zeroes) {
            row_min_zeroes = row_zeroes;
            idx_zeroes = i;
        }
    }

    printf("Строка с минимальным количеством нулевых элементов: %d\n", idx_zeroes);
}
