#include "logic/flight.h"
#include "io/writer.h"
#include "io/reader.h"
#include <stdio.h>

int main(void)
{
    if (readBase() != 0) {
        printf("Произошла ошибка при чтении базового файла!");
        return 1;
    }
    printDefault("ВСЕ ЗАПИСИ");

    puts("Добавить дополнительные поля? Нажмите любую кнопку для подтверждения.");
    readAdditional();
    printDefault("ВСЕ ЗАПИСИ");

    return 0;
}
