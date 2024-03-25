#define  _GNU_SOURCE

#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include "../logic/flight.h"
#include "../logic/codificator.h"

#define BASE_INFO_SIZE (30)
#define ADDITIONAL_INFO_SIZE (BASE_INFO_SIZE + 4)
#define CODIFICATOR_INFO_SIZE (25)

static const char* BASE_INFO_FILE_NAME = "data/base.data";
static const char* ADDITIONAL_INFO_FILE_NAME = "data/additional.data";
static const char* CODIFICATOR_INFO_FILE_NAME = "data/code.data";

static FILE *base_info_fp = NULL;
static FILE *additional_info_fp = NULL;
static FILE *codificator_info_fp = NULL;

static void openBase(void)
{
    base_info_fp = fopen(BASE_INFO_FILE_NAME, "r");
    if (base_info_fp == NULL)
        printf("Ошибка чтения файла с базовыми данными!");
}

static void openAdditional(void)
{
    additional_info_fp = fopen(ADDITIONAL_INFO_FILE_NAME, "r");
    if (additional_info_fp == NULL)
        printf("Ошибка чтения файла с дополнительными данными!");
}

static void openCodificator(void)
{
    codificator_info_fp = fopen(CODIFICATOR_INFO_FILE_NAME, "r");
    if (codificator_info_fp == NULL)
        printf("Ошибка чтения файла с кодификаторами!");
}

static void closeBase(void)
{
    if (base_info_fp == NULL) {
        printf("Базовый файл либо не был открыт, либо уже закрыт!");
    } else {
        fclose(base_info_fp);
    }
}

static void closeAdditional(void)
{
    if (additional_info_fp == NULL) {
        printf("Дополнительный файл либо не был открыт, либо уже закрыт!");
    } else {
        fclose(additional_info_fp);
    }
}

static void closeCodificator(void)
{
    if (codificator_info_fp == NULL) {
        printf("Файл с кодификатором либо не был открыт, либо уже закрыт!");
    } else {
        fclose(additional_info_fp);
    }
}

static flight serializeFormattedLine(char* line)
{
    char* parsed = strtok(line, " ");
    int id = atoi(parsed);
    if (id == 0) {
        printf("Поле с идентификатором полета не может быть пустым!\n");
        exit(EXIT_FAILURE);
    }

    parsed = strtok(NULL, " ");
    int destination_temp = atoi(parsed);
    char* destination = codificatorListGet(destination_temp);

    parsed = strtok(NULL, " ");
    double distance = atof(parsed);

    parsed = strtok(NULL, ",");
    float adult = atoi(parsed);
    parsed = strtok(NULL, " ");
    float child = atoi(parsed);
    flightCost cost = flightCostCreate(adult, child);

    parsed = strtok(NULL, ":");
    int start_hours = atoi(parsed);
    parsed = strtok(NULL, "-");
    int start_minutes = atoi(parsed);
    time start_time = timeCreate(start_hours, start_minutes);

    parsed = strtok(NULL, ":");
    int end_hours = atoi(parsed);
    parsed = strtok(NULL, "");
    int end_minutes = atoi(parsed);
    time end_time = timeCreate(end_hours, end_minutes);

    flightDuration duration = flightDurationCreate(start_time, end_time);

    flight result = flightCreate(id, distance, destination, cost, duration);
    return result;
}

static codificator serializeFormattedCodificatorLine(char* line)
{
    char* parsed = strtok(line, " ");
    int id = atoi(parsed);

    parsed = strtok(NULL, " ");
    char* destination = strdup(parsed);

    codificator result = { .id = id, .destination = destination };
    return result;
}

// TODO: error handling
static flight parseLineBase(void)
{
    FILE* fp = base_info_fp;
    char* line = NULL;
    size_t len = 0;
    ssize_t read;
    flight result;

    if (fp == NULL)
        printf("Ошибка чтения базового файла при парсинге!");

    if ((read = getline(&line, &len, base_info_fp)) != -1) {
        result = serializeFormattedLine(line);
        if (line)
            free(line);
    } else {
        printf("Ошибка при парсинге базового файла!");
        exit(1);
    }

    return result;
}

// TODO: error handling
static flight parseLineAdditional(void)
{
    FILE* fp = additional_info_fp;
    char* line = NULL;
    size_t len = 0;
    ssize_t read;
    flight result;

    if (fp == NULL) {
        printf("Ошибка чтения дополнительного файла при парсинге!");
        exit(EXIT_FAILURE);
    }

    if ((read = getline(&line, &len, base_info_fp)) != -1) {
        result = serializeFormattedLine(line);
        if (line)
            free(line);
    } else {
        printf("Ошибка при парсинге дополнительного файла!");
        exit(EXIT_FAILURE);
    }

    return result;
}

static codificator parseLineCodificator(void)
{
    FILE* fp = codificator_info_fp;
    char* line = NULL;
    size_t len = 0;
    ssize_t read;
    codificator result;

    if (fp == NULL) {
        printf("Ошибка чтения дополнительного файла при парсинге!");
        exit(EXIT_FAILURE);
    }

    if ((read = getline(&line, &len, base_info_fp)) != -1) {
        result = serializeFormattedCodificatorLine(line);
        if (line)
            free(line);
    } else {
        printf("Ошибка при парсинге дополнительного файла!");
        exit(EXIT_FAILURE);
    }

    return result;
}

int readBase(void)
{
    openBase();
    for (int i = 0; i < BASE_INFO_SIZE; i++) {
        flight result = parseLineBase();
        if (flightListInsert(i, result) != 0) {
            printf("Вставка в список основных полетов вернула ошибку!\n");
            i--;
            continue;
        }
    }
    closeBase();

    return 0;
}

int readAdditional(void)
{
    openAdditional();
    for (int i = BASE_INFO_SIZE - 1; i < ADDITIONAL_INFO_SIZE; i++) {
        flight result = parseLineAdditional();
        if (flightListInsert(i, result) != 0) {
            printf("Вставка в список дополнительных полетов вернула ошибку!\n");
            continue;
        }
    }
    closeAdditional();

    return 0;
}

int readCodificator(void)
{
    openCodificator();
    for (int i = 0; i < CODIFICATOR_INFO_SIZE; i++) {
        codificator result = parseLineCodificator();
        if (codificatorListInsert(result) != 0) {
            printf("Вставка в список кодификаторов вернула ошибку!\n");
            continue;
        }
    }
    closeCodificator();

    return 0;
}
