#include <stdio.h>
#include <stdlib.h>
#include "codificator.h"

// emulate hashmap with array of size of all possible indexes
// that'll store at each index their values
// ATTENTION: works only if indexes are interpreted as IDs
#define CODIFICATOR_LIST_SIZE (1000)

static char* codificator_list[CODIFICATOR_LIST_SIZE] = {0};

int codificatorListInsert(codificator item)
{
    if (item.id > CODIFICATOR_LIST_SIZE - 1 | item.id < 0) {
        printf("Ошибка индекса в списке кодификаторов!\n");
        return 1;
    } else {
        codificator_list[item.id] = item.destination;
        return 0;
    }

    return 1;
}

char* codificatorListGet(int idx)
{
    if (idx > CODIFICATOR_LIST_SIZE - 1 | idx < 0) {
        printf("Ошибка индекса в списке кодификаторов!\n");
        exit(EXIT_FAILURE);
    }

    return codificator_list[idx];
}
