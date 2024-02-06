#include <stdlib.h>
#include "flight.h"

// TODO: check for price lower than zero
flightCost flightCostCreate(const int adult, const int child) {
    flightCost result = {
        .adult = adult,
        .child = child,
    };

    return result;
}

time timeCreate(const int hours, const int minutes) {
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

// TODO:
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

// made for reading convinience
#ifndef FLIGHT_LIST_AMOUNT
    #define FLIGHT_LIST_AMOUNT 50
#endif
static flight flightList[FLIGHT_LIST_AMOUNT] = {0};
static flight flightListSorted[FLIGHT_LIST_AMOUNT] = {0};

// 0 if inserted successfully;
// 1 if some else (i.e. out of bounds)
int flightListInsert(int idx, flight elem) {
    if (idx >= 50 || idx < 0) {
        return 1;
    } else {
        // check if previous element by index - 1 is present
        // to save array coherence
        if (idx != 0) {
            if (flightList[idx - 1].id == 0) {
                return 1;
            }
        }
        flightList[idx] = elem;
        return 0;
    }
}

// TODO: handle situations where you
// may access out of bounds or negative indices
flight flightListGet(int idx) {
    return flightList[idx];
}

int flightListLen() {
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

// TODO: handle situations where you
// may access out of bounds or negative indices
flight flightListSortedGet(int idx) {
    return flightListSorted[idx];
}

static void swap(int i, int j) 
{ 
    flight temp = flightListSorted[i]; 
    flightListSorted[i] = flightListSorted[j]; 
    flightListSorted[j] = temp; 
}
  
static void bubbleSort()
{
    int len = flightListLen();

    int i, j;
    for (i = 0; i < len - 1; i++) 
        for (j = 0; j < len - i - 1; j++) 
            if (flightListSorted[j].id > flightListSorted[j + 1].id) 
                swap(j, j + 1); 
} 

void flightListSort() {
    for (size_t i = 0; i < FLIGHT_LIST_AMOUNT; i++) {
        flightListSorted[i] = flightList[i];
    }
    bubbleSort();
}
