#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "io/writer.h"
#include "io/reader.h"
#include "logic/flight.h"

static void printInfo() {
    printf("1 - показать текущую таблицу;\n");
    printf("2 - догрузить дополнительную таблицу;\n");
    printf("0 - выход из программы;\n");
}

int main(void)
{
    bool base_state = false;
    bool additional_state = false;

    system("clear");
    do {
        int input;
        printInfo();

        printf("Ваш ввод: ");
        scanf("%i", &input);
        system("clear");

        if (input == 0) break;
        if (input == 1) {
            if (!base_state) {
                readBase();
                base_state = true;
                printDefault("ТЕКУЩАЯ ТАБЛИЦА");
            } else {
                printDefault("ТЕКУЩАЯ ТАБЛИЦА");
            }
        };
        if (input == 2) {
            if (!additional_state) {
                if (!base_state) {
                    readBase();
                    base_state = true;
                    additional_state = true;
                    readAdditional();
                    printDefault("ОБЩАЯ ТАБЛИЦА");
                } else {
                    readAdditional();
                    printDefault("ОБЩАЯ ТАБЛИЦА");
                    additional_state = true;
                }
            } else {
                additional_state = true;
            }
        };

        if (input == 0) break;
        
        if (input < 0 || input > 2) continue;
    } while (1);

    return 0;
}
