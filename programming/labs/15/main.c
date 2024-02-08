#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>

#define STR_SIZE 512
#define WORDS_AMOUNT 64

static inline int readUserInput(char* buf)
{
    printf("Введите строку: ");
    char* get_status = fgets(buf, STR_SIZE, stdin);

    if (get_status == NULL) {
        return 1;
    }

    return 0;
}

static inline int trimLeadingAndTrailing(char* str)
{
    char* end;

    while (isspace((unsigned char)*str)) str++;

    if (*str == 0)
        return 1;

    end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end)) end--;

    end[1] = '\0';

    return 0;
}

static inline void splitWhitespace(char* src, char** dst, int* size)
{
    int i = 0;
    char* token = strtok(src, " ");
    while (token != NULL) {
        dst[i] = token;
        token = strtok(NULL, " ");
        i++;
    }
    *size = i;
}

static inline int filterByCondition(char** words, int* size)
{
    char* temp[WORDS_AMOUNT];
    int temp_size = 0;
    bool bad;

    for (int i = 0; i < *size; i++) {
        if (strlen(words[i]) > 4) {
            bad = false;
            for (int j = 0; j < 4; j++) {
                if (!islower(words[i][j])) {
                    bad = true;
                    break;
                }
            }

            if (!bad) {
                temp[temp_size] = words[i];
                temp_size++;
            }
        }
    }

    if (temp_size == 0) {
        return 1;
    }

    memcpy(words, temp, temp_size * sizeof(char*));
    *size = temp_size;

    return 0;
}

static inline void printResults(char** words, const int size)
{
    printf("Результат:\n");
    for (int i = 0; i < size; i++) {
        printf("%i) %s\n", i + 1, words[i]);
    }
}

static inline int processInput(char* input, char** words)
{
    int size = 0;

    if (readUserInput(input) != 0) {
        printf("Ошибка! Не удалось прочитать строку.\n");
        return 1;
    }

    if (trimLeadingAndTrailing(input) == 1) {
        printf("Результат: \n");
        return 0;
    }

    splitWhitespace(input, words, &size);

    if (filterByCondition(words, &size) != 0) {
        printf("Ошибка! Не удалось отфильтровать слова.\n");
        return 1;
    }

    printResults(words, size);

    return 0;
}

int main(void)
{
    int amount;
    printf("Введите количество вводимых предложений: ");
    scanf("%i", &amount);
    // flush stdin buffer
    while ((getchar()) != '\n');

    if (amount < 1) {
        printf("Хорошо, завершаю программу.");
        return 0;
    }

    for (int i = 0; i < amount; i++) {
        char input[STR_SIZE];
        char* words[WORDS_AMOUNT];
        
        if ((processInput(input, words)) != 0) {
            return 1;
        }
    }

    return 0;
}
