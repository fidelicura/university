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

    if (getchar() == 0) {
        readAdditional();
        printDefault("ВСЕ ЗАПИСИ");
        return 0;
    } else {
        return 1;
    }
}
