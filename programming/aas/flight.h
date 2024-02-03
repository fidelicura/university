#pragma once

typedef struct {
    float adult;
    float child;
} flightCost;
static flightCost flightCostCreate(const float adult, const float child);

typedef int flightDuration;

typedef struct {
    int id;
    const char* destination;
    double distance;
    flightCost cost;
    flightDuration duration;
} flight;

static flight flightCreate(
    const int id, const double distance, const char* destination,
    const flightCost cost, const flightDuration duration
);

#define FLIGHT_LIST_AMOUNT 50
static int flightListInsert(int idx, flight elem);
static flight flightListGet(int idx);

typedef enum {
    Descending,
    Ascending,
} sortType;

static void flightListSort(const sortType type);
