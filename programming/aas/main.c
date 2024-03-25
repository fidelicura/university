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
    printf("7 - изменить поле с информацией\n");
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
        } else if (input == 7) {
            if (!base_state) {
                readBase();
                base_state = true;
            }

            system("clear");
            printf("Введите соответствующую цифру:\n");
            printf("1 - изменить идентификатор\n");
            printf("2 - изменить город направления\n");
            printf("3 - изменить расстояние\n");
            printf("4 - изменить цену\n");
            printf("5 - изменить время\n");
            printf("Ваш вариант: ");
            scanf("%i", &input);

            if (input == 1) {
                int input;
                system("clear");
                printf("Вы выбрали изменить идентификатор.\n");
                printf("Ввод: ");
                scanf("%i", &input);
            } else if (input == 2) {
                char* input;
                system("clear");
                printf("Вы выбрали изменить город направления.\n");
                printf("Ввод: ");
                scanf("%s", input);
            } else if (input == 3) {
                double input;
                system("clear");
                printf("Вы выбрали изменить расстояние.\n");
                printf("Ввод: ");
                scanf("%lf", &input);
            } else if (input == 4) {
                int first, second;
                system("clear");
                printf("Вы выбрали изменить цену.\n");
                printf("Ввод в формате \"40150 , 35730\": ");
                scanf("%i , %i", &first, &second);
            } else if (input == 5) {
                char* input;
                system("clear");
                printf("Вы выбрали изменить время.\n");
                printf("Ввод в формате \"20:00-18:30\": ");
                scanf("%s", input);
            }
        }

        if (input == 0) break;
        
        if (input < 0 || input > 7) continue;
    } while (1);

    return 0;
}
