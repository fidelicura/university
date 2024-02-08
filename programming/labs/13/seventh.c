#include <stdio.h>

#define MAX_SIZE 100

void rfrom_stdin(int arr[], int* size);
void rfrom_file(int arr[], int* size, const char* filename);

void determine_min(const int input[], const int* size, int output[]);

void wto_stdout(const int arr[], int size);
void wto_file(const int arr[], int size);

int main(void)
{
    int arr[MAX_SIZE];
    int size = 0;

    int user_input;
    printf("0 - прочитать массивы из файлов\n1 - самостоятельный ввод массива\n");
    printf("Вариант: ");
    scanf("%i", &user_input);

    if (user_input == 1) {
        rfrom_stdin(arr, &size);
        wto_stdout(arr, size);
        wto_file(arr, size);
    } else if (user_input == 0) {
        rfrom_file(arr, &size, "x.dat");
        wto_stdout(arr, size);
        wto_file(arr, size);

        int arr2[MAX_SIZE];
        int size2 = 0;
        rfrom_file(arr2, &size2, "y.dat");
        wto_stdout(arr2, size2);
        wto_file(arr2, size2);

        int arr3[MAX_SIZE];
        int size3 = 0;
        rfrom_file(arr3, &size3, "z.dat");
        wto_stdout(arr3, size3);
        wto_file(arr3, size3);
    } else {
        printf("Вы ввели неправильноe значение!");
        return 1;  
    }


    return 0;
}


void rfrom_stdin(int arr[], int* size)
{
    printf("Введите массив (разделите числа пробелами): ");
    
    while (*size < MAX_SIZE) {
        if (scanf("%d", &arr[*size]) == 1) {
            (*size)++;
        } else {
            break;
        }
    }
}

void rfrom_file(int arr[], int* size, const char* filename)
{
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("Ошибка при открытии файла.\n");
        return;
    }

    while (*size < MAX_SIZE) {
        if (fscanf(file, "%d", &arr[*size]) == 1) {
            (*size)++;
        } else {
            break;
        }
    }

    fclose(file);
}


void determine_min(const int input[], const int* size, int output[])
{
    int min_val = input[0];
    int min_idx = 0;

    for (int i = 1; i < *size; i++) {
        if (input[i] < min_val) {
            min_val = input[i];
            min_idx = i;
        }
    }

    output[0] = min_val;
    output[1] = min_idx;
}


void wto_stdout(const int arr[], int size)
{
    int minimals[2];
    determine_min(arr, &size, minimals);

    printf("[");

    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);

        if (i < size - 1) {
            printf(", ");
        }
    }

    printf("] - (%d, %d)\n", minimals[0], minimals[1]);
}

void wto_file(const int arr[], int size)
{
    FILE *file = fopen("result.txt", "a");

    if (file == NULL) {
        printf("Ошибка при открытии файла.\n");
        return;
    }

    int minimals[2];
    determine_min(arr, &size, minimals);

    fprintf(file, "[");

    for (int i = 0; i < size; i++) {
        fprintf(file, "%d", arr[i]);

        if (i < size - 1) {
            fprintf(file, ", ");
        }
    }

    fprintf(file, "] - (%d, %d)\n", minimals[0], minimals[1]);

    fclose(file);
}
