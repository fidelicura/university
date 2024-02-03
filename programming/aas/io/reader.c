#include <stdio.h>
#include "../logic/flight.h"

static const char* BASE_INFO_FILE_NAME = "base.data";
static const char* ADDITIONAL_INFO_FILE_NAME = "additional.data";

static FILE *base_info_fp = NULL;
static FILE *additional_info_fp = NULL;

static void openBase(void) {
    base_info_fp = fopen(BASE_INFO_FILE_NAME, "r");
    if (base_info_fp == NULL)
        exit(1);
}

static void openAdditional(void) {
    additional_info_fp = fopen(ADDITIONAL_INFO_FILE_NAME, "r");
    if (additional_info_fp == NULL)
        exit(1);
}

static void closeBase(void) {}

static void closeAdditional(void) {}

// TODO: error handling
static flight parseLineBase(FILE* fp) {
    if (fp == NULL)
        exit(1);
}

// TODO: error handling
static flight parseLineAdditional(FILE* fp) {
    if (fp == NULL)
        exit(1);
}

static int readBase(void) {
    return 0;
}

static int readAdditional(void) {
    return 0;
}
