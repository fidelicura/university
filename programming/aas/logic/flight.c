#include <stdio.h>
#include <stdlib.h>
#include "flight.h"

// TODO: check for price lower than zero
flightCost flightCostCreate(const int adult, const int child)
{
    flightCost result = {
        .adult = adult,
        .child = child,
    };

    return result;
}

time timeCreate(const int hours, const int minutes)
{
    time result = {
        .hours = hours,
        .minutes = minutes,
    };

    return result;
}

flightDuration flightDurationCreate(const time start, const time end) {
    flightDuration result = {
        .start = start,
        .end = end,
    };

    return result;
}

// TODO (possible):
// - check for distance and duration lower than zero
// - check for id lower or equal zero 
flight flightCreate(
    const int id, const double distance, const char* destination,
    const flightCost cost, const flightDuration duration
) {
    flight result = {
        .id = id,
        .destination = destination,
        .distance = distance,
        .cost = cost,
        .duration = duration,
    };

    return result;
}

#ifndef FLIGHT_LIST_AMOUNT
    #define FLIGHT_LIST_AMOUNT 50
#endif
static flight flightList[FLIGHT_LIST_AMOUNT] = {0};
static flight flightListSortedById[FLIGHT_LIST_AMOUNT] = {0};
static flight flightListSortedByMax[FLIGHT_LIST_AMOUNT] = {0};

// 0 if inserted successfully;
// 1 if some else (i.e. out of bounds)
int flightListInsert(int idx, flight elem)
{
    if (idx >= FLIGHT_LIST_AMOUNT || idx < 0) {
        printf("IDX IS NOT FINE!");
        return 1;
    } else {
        flightList[idx] = elem;
        return 0;
    }
}

// TODO: handle situations where you
// may access out of bounds or negative indices
flight flightListGet(int idx)
{
    if (idx >= FLIGHT_LIST_AMOUNT || idx < 0) {
        printf("PANIC! out of bounds");
        exit(EXIT_FAILURE);
    }
    
    return flightList[idx];
}

int flightListLen(void)
{
    int counter = 0;

    for (int i = 0; i < FLIGHT_LIST_AMOUNT; i++) {
        if (!(flightList[i].id <= 0)) {
            counter += 1;
        } else {
            break;
        }
    }

    return counter;
}

flight flightListSortedByIdGet(int idx)
{
    if (idx > FLIGHT_LIST_AMOUNT || idx < 0)
        exit(EXIT_FAILURE);

    return flightListSortedById[idx];
}

static void swapById(int i, int j) 
{ 
    flight temp = flightListSortedById[i]; 
    flightListSortedById[i] = flightListSortedById[j]; 
    flightListSortedById[j] = temp; 
}
  
static void bubbleSortById(void)
{
    int len = flightListLen();

    int i, j;
    for (i = 0; i < len - 1; i++) 
        for (j = 0; j < len - i - 1; j++) 
            if (flightListSortedById[j].id > flightListSortedById[j + 1].id) 
                swapById(j, j + 1);
} 

static void swapByMax(int i, int j) 
{ 
    flight temp = flightListSortedByMax[i]; 
    flightListSortedByMax[i] = flightListSortedByMax[j]; 
    flightListSortedByMax[j] = temp; 
}

static void bubbleSortByMax(void)
{
    int len = flightListLen();

    int i, j;
    for (i = 0; i < len - 1; i++) 
        for (j = 0; j < len - i - 1; j++) 
            if (flightListSortedByMax[j].distance < flightListSortedByMax[j + 1].distance) 
                swapByMax(j, j + 1); 
} 

flight* flightListFind(int id)
{
    for (int i = 0; i < flightListLen(); i++) {
        if (flightList[i].id == id) {
            return &flightList[i];
        }
    }

    return NULL;
}

void flightListSortById(void)
{
    for (size_t i = 0; i < FLIGHT_LIST_AMOUNT; i++) {
        flightListSortedById[i] = flightList[i];
    }
    bubbleSortById();
}

flight flightListSortedByMaxGet(int idx)
{
    return flightListSortedByMax[idx];
}

void flightListSortByMax(void)
{
    for (size_t i = 0; i < FLIGHT_LIST_AMOUNT; i++) {
        flightListSortedByMax[i] = flightList[i];
    }
    bubbleSortByMax();
}

void flightChangeId(flight* obj, int value)
{
    obj->id = value;
}

void flightChangeDestination(flight* obj, const char* value)
{
    obj->destination = value;
}

void flightChangeDistance(flight* obj, double value)
{
    obj->distance = value;
}

void flightChangeCost(flight* obj, flightCost value)
{
    obj->cost = value;
}

void flightChangeDuration(flight* obj, flightDuration value)
{
    obj->duration = value;
}
