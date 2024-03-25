#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "io/writer.h"
#include "io/reader.h"

static void printInfo(void) {
    printf("1 - показать текущую таблицу;\n");
    printf("2 - догрузить дополнительную таблицу;\n");
    printf("3 - показать таблицу с сортировкой по ID;\n");
    printf("4 - показать таблицу по указанному городу;\n");
    printf("5 - показать таблицу самых дальних трех полетов;\n");
    printf("6 - выгрузить таблицу как архивный файл\n");
    printf("0 - выход из программы;\n");
}

int main(void)
{
    bool base_state = false;
    bool additional_state = false;
    readCodificator();

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
                printDefault();
            } else {
                printDefault();
            }
        }
        else if (input == 2) {
            if (!additional_state) {
                if (!base_state) {
                    readBase();
                    readAdditional();
                    base_state = true;
                    additional_state = true;
                    printDefault();
                } else {
                    readAdditional();
                    printDefault();
                    additional_state = true;
                }
            } else {
                additional_state = true;
                printDefault();
            }
        } else if (input == 3) {
            if (!additional_state) {
                if (!base_state) {
                    readBase();
                    readAdditional();
                    base_state = true;
                    additional_state = true;
                    printSorted();
                } else {
                    readAdditional();
                    additional_state = true;
                    printSorted();
                }
            } else {
                additional_state = true;
                printSorted();
            }
        } else if (input == 4) {
            if (!base_state) {
                readBase();
                base_state = true;
            }

            char user_input[50];
            printf("Введите город назначения: ");
            scanf("%s", user_input);
            printf("Вы ввели: \"%s\"\n", user_input);
            printDefined(user_input);
        } else if (input == 5) {
            if (!base_state) {
                readBase();
                base_state = true;
            }

            printMaxDuration();
        } else if (input == 6) {
            if (!base_state) {
                readBase();
                base_state = true;
            }

            uploadDefault();
        }

        if (input == 0) break;
        
        if (input < 0 || input > 6) continue;
    } while (1);

    return 0;
}
