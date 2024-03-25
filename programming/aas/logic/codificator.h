typedef struct {
    int id;
    char* destination;
} codificator;

int codificatorListInsert(codificator item);

char* codificatorListGet(int idx);
