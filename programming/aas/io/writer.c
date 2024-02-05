#define  _GNU_SOURCE

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "writer.h"
#include "../logic/flight.h"

#define TABLE_MAX_WIDTH 70

// WARNING: pass only one line header
static void printHeader(const char* header) {
    int len = strlen(header);

    for (int i = 0; i < (len - 5); i++) {
        putc('-', stdout);
    }
    putc('\n', stdout);

    putc('|', stdout);
    putc(' ', stdout);
    for (int i = 0; i < len; i++) {
        putc(header[i], stdout);
    }
    putc(' ', stdout);
    putc('|', stdout);
    putc('\n', stdout);
}

static void printDelimiter() {
    for (int i = 0; i < TABLE_MAX_WIDTH; i++)
        putc('-', stdout);
    putc('\n', stdout);
}

static void printLine(flight data) {
    char spaces[21];
    size_t len = 21 - strlen(data.destination) / 2;
    // don't really work at combo of different byte chars in one string
    // e.g. "Ивано-Франковск" due to '-' one byte and other Russian letters
    // cost 2 bytes...
    for (size_t i = 0; i < len; i++) {
        spaces[i] = ' ';
    }
    spaces[len - 1] = '\0';

    printf(
        "| %3i | %s%s | %6.2f | %-6i,%6i | %02i:%02i%c%02i:%02i |\n",
        data.id, data.destination, spaces, data.distance,
        data.cost.adult, data.cost.child,
        data.duration.start.hours, data.duration.start.minutes, 
        '-',
        data.duration.end.hours, data.duration.end.minutes 
    );
}

void printDefault(const char* header) {
    printHeader(header);
    printDelimiter();
    for (int i = 0; i < flightListLen(); i ++) {
        flight line = flightListGet(i);
        printLine(line);
    }
    printDelimiter();
}

void printSorted(const char* header) {
    printHeader(header);
}

void printDefined(const char* header) {
    printHeader(header);
}

void printMaxDuration(const char* header) {
    printHeader(header);
}
