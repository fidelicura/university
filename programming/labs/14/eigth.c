#include <stdio.h>
#include <stdlib.h>

#define MAX_VALUES 100

int read_file(float values[]);
void insert_value(float values[], int* size, float user_value);
void sort_array(float values[], int size);
void write_file(float values[], int size);

int main(void) {
    float values[MAX_VALUES];
    int size = read_file(values);

    float user_value;
    printf("Введите ваше число в формате float: ");
    scanf("%f", &user_value);

    insert_value(values, &size, user_value);
    sort_array(values, size);
    write_file(values, size);

    return 0;
}


int read_file(float values[])
{
    FILE *file = fopen("result.txt", "r");
    if (file == NULL) {
        printf("Ошибка во время открытия файла `result.txt` на чтение!");
        exit(1);
    }

    int size = 0;
    while (fscanf(file, "%f", &values[size]) == 1) {
        size++;
    }

    fclose(file);
    return size;
}

void insert_value(float values[], int* size, float user_value)
{
    int i;
    for (i = *size - 1; i >= 0; i--) {
        if (user_value > values[i]) {
            values[i + 1] = values[i];
        } else {
            break;
        }
    }
    values[i + 1] = user_value;
    (*size)++;
}

void sort_array(float values[], int size)
{
    int i, j;
    for (i = 0; i < size - 1; i++) {
        for (j = i + 1; j < size; j++) {
            if (values[i] < values[j]) {
                float temp = values[i];
                values[i] = values[j];
                values[j] = temp;
            }
        }
    }
}

void write_file(float values[], int size)
{
    FILE *file = fopen("result.txt", "w");
    if (file == NULL) {
        printf("Ошибка во время открытия файла `result.txt` на запись!");
        exit(1);
    }

    for (int i = 0; i < size; i++) {
        fprintf(file, "%f ", values[i]);
    }

    fclose(file);
}
