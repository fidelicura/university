#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STR_SIZE 1024
#define WORDS_AMOUNT 64

static inline void handleMallocFail(void* mem)
{
    if (mem == NULL) {
        printf("Ошибка #1! Невозможно выделить больше памяти на куче.");
        exit(EXIT_FAILURE);
    }
}

typedef struct Leaf {
    int data;
    struct Leaf* next;
} Leaf;

typedef struct {
    struct Leaf* root;
} LinkedList;

static LinkedList linkedListCreateValue(int val)
{
    void* leaf_mem = malloc(sizeof(Leaf));
    handleMallocFail(leaf_mem);

    Leaf* leaf = leaf_mem;
    leaf->data = val;
    leaf->next = NULL;

    LinkedList result;
    result.root = leaf;

    return result;
}

static void linkedListAppendValue(LinkedList* src, int value)
{
    Leaf* root = src->root;

    void* new_leaf_mem = malloc(sizeof(Leaf));
    handleMallocFail(new_leaf_mem);

    Leaf* new_leaf = new_leaf_mem;
    new_leaf->data = value;
    new_leaf->next = NULL;

    if (root == NULL) {
        src->root = new_leaf;
    } else {
        while (root->next != NULL) {
            root = root->next;
        }
        root->next = new_leaf;
    }
}

static LinkedList linkedListCreateFill(int* src, unsigned int size)
{
    LinkedList list = linkedListCreateValue(src[0]);
    for (unsigned int i = 1; i < size; i ++)
        linkedListAppendValue(&list, src[i]);

    return list;
}

static int* linkedListGet(LinkedList* src, unsigned int idx)
{
    Leaf* root = src->root;

    if (root == NULL) {
        printf("Ошибка #2! Попытка получить неинициализированный элемент.");
        exit(EXIT_FAILURE);
    }

    unsigned int i =  0;
    while (root != NULL && i < idx) {
        root = root->next;
        i++;
    }

    if (root == NULL || i != idx) {
        printf("Ошибка #3! Попытка получить неинициализированный элемент.");
        exit(EXIT_FAILURE);
    }

    return &root->data;
}

static void readFileData(char* data)
{
    FILE* fp = fopen("input.data", "r");
    if (fp == NULL) {
        printf("Ошибка #4! Невозможно открыть указанный файл.");
        exit(EXIT_FAILURE);
    }

    fgets(data, STR_SIZE, fp);

    fclose(fp);
}

static unsigned int parseData(char* data, int* buf)
{
    unsigned int i = 0;
    char* token = strtok(data, " ");

    if (token != NULL) {
        buf[i] = atoi(token);
        i++;
    }

    while ((token = strtok(NULL, " ")) != NULL) {
        buf[i] = atoi(token);
        i++;
    }

    return i;
}

static void swap(int* x, int* y)
{
    int temp = *y;
    *y = *x;
    *x = temp;
}

static void linkedListProcess(LinkedList* src, unsigned int size)
{
    for (unsigned int i = 1; i < size; i += 2) {
        int* left = linkedListGet(src, i - 1);
        int* right = linkedListGet(src, i);
        swap(left, right);
    }
}

static void linkedListPrinter(LinkedList* src)
{
    Leaf* current = src->root;
    while (current != NULL) {
        printf("%i ", current->data);
        current = current->next;
    }
}

int main(void)
{
    int values[WORDS_AMOUNT];
    char data[STR_SIZE];

    readFileData(data);
    unsigned int size = parseData(data, values);
    LinkedList list = linkedListCreateFill(values, size);
    linkedListProcess(&list, size);
    linkedListPrinter(&list);

    return 0;
}
