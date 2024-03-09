#define  _GNU_SOURCE

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "writer.h"
#include "../logic/flight.h"

#define TABLE_MAX_WIDTH 71

static void printDelimiter(void);

static void printHeader(void)
{
    printDelimiter();

    printf("|");
    printf(" ");
    // printf("%-*s", TABLE_MAX_WIDTH + 10, header);
    printf(" №  |");
    printf(" %-24s  |", "Город");
    printf(" %-11s  |", "Путь");
    printf(" %-16s  |", "Цена");
    printf(" %-15s  ", "Время");
    printf("|");
    printf("\n");
}

static void printDelimiter(void)
{
    for (int i = 0; i < TABLE_MAX_WIDTH; i++)
        putc('-', stdout);
    putc('\n', stdout);
}

// of diffbyte chars in single string
static void printLine(flight data)
{
    char destination_spaces[21];
    size_t dest_len = 21 - strlen(data.destination) / 2;
    // don't really work at combo of different byte chars in one string
    // e.g. "Ивано-Франковск" due to '-' one byte and other Russian letters
    // cost 2 bytes...
    for (size_t i = 0; i < dest_len; i++) {
        destination_spaces[i] = ' ';
    }
    destination_spaces[dest_len - 1] = '\0';

    printf(
        "| %3i | %s%s | %8.2f | %-6i,%6i | %02i:%02i%c%02i:%02i |\n",
        data.id, data.destination, destination_spaces, data.distance,
        data.cost.adult, data.cost.child,
        data.duration.start.hours, data.duration.start.minutes, 
        '-',
        data.duration.end.hours, data.duration.end.minutes 
    );
}

// of diffbyte chars in single string
static void outputLine(flight data, FILE* fp)
{
    char destination_spaces[21];
    size_t dest_len = 21 - strlen(data.destination) / 2;
    // don't really work at combo of different byte chars in one string
    // e.g. "Ивано-Франковск" due to '-' one byte and other Russian letters
    // cost 2 bytes...
    for (size_t i = 0; i < dest_len; i++) {
        destination_spaces[i] = ' ';
    }
    destination_spaces[dest_len - 1] = '\0';

    char line[512];
    sprintf(
        line,
        "| %3i | %s%s | %8.2f | %-6i,%6i | %02i:%02i%c%02i:%02i |\n",
        data.id, data.destination, destination_spaces, data.distance,
        data.cost.adult, data.cost.child,
        data.duration.start.hours, data.duration.start.minutes, 
        '-',
        data.duration.end.hours, data.duration.end.minutes 
    );

    fputs(line, fp);
}

void printDefault(void)
{
    printHeader();
    printDelimiter();
    for (int i = 0; i < flightListLen(); i++) {
        flight line = flightListGet(i);
        printLine(line);
    }
    printDelimiter();
}

void printSorted(void)
{
    flightListSortById();
    printHeader();
    printDelimiter();
    for (int i = 0; i < flightListLen(); i++) {
        flight line = flightListSortedByIdGet(i);
        printLine(line);
    }
    printDelimiter();
}

void printDefined(const char* defined_destination)
{
    int buf[FLIGHT_LIST_AMOUNT];
    int j = 0;
    bool state = false;

    for (int i = 0; i < flightListLen(); i++) {
        flight line = flightListGet(i);
        if (!strcmp(line.destination, defined_destination)) {
            buf[j] = i;
            j++;
            state = true;
        }
    }

    if (state == false) {
        printf("Нет подходящих записей!\n");
    } else {
        printHeader();
        printDelimiter();
        for (int i = 0; i < j; i++) {
            flight line = flightListGet(buf[i]);
            printLine(line);
        }
        printDelimiter();
    }
}

void printMaxDuration(void)
{
    flightListSortByMax();
    printHeader();
    printDelimiter();
    for (int i = 0; i < 3; i++) {
        flight line = flightListSortedByMaxGet(i);
        printLine(line);
    }
    printDelimiter();
}

void uploadDefault(void)
{
    FILE* fp = fopen("result.data", "w+");
    if (fp == NULL) {
        printf("Ошибка открытия/создания файла-архива!");
    }

    for (int i = 0; i < flightListLen(); i++) {
        flight line = flightListGet(i);
        outputLine(line, fp);
    }

    fclose(fp);
    printf("Данные записаны в файл.\n");
}
