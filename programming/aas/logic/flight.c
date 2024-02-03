#include "flight.h"

static flightCost flightCostCreate(const float adult, const float child) {
    flightCost result = {
        .adult = adult,
        .child = child,
    };

    return result;
}

static flight flightCreate(
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

// 0 if inserted successfully;
// 1 if some else (i.e. out of bounds)
static int flightListInsert(int idx, flight elem) {
    if (idx >= 50 || idx < 0) {
        return 1;
    } else {
        flightList[idx] = elem;
        return 0;
    }
}

// TODO: handle situations where you
// may access out of bounds or negative indices
static flight flightListGet(int idx) {
    return flightList[idx];
}

static void __flightListDescendingSort();
static void __flightListAscendingSort();

static void flightListSort(const sortType type) {
    if (type == Descending) {
        __flightListDescendingSort();
    } else {
        __flightListAscendingSort();
    }
}

static int __quickSortPartition(const int low, const int high);

// in-place quicksort
static void __flightListDescendingSort(const int low, const int high) {
    if (low < high) {
        int idx = __quickSortPartition(low, high);
        __flightListDescendingSort(low, idx - 1);
        __flightListDescendingSort(idx + 1, high);
    }
}

// in-place quicksort
static void __flightListAscendingSort(const int low, const int high) {
    if (low < high) {
        int idx = __quickSortPartition(low, high);
        __flightListAscendingSort(low, idx - 1);
        __flightListAscendingSort(idx + 1, high);
    }
}

// quicksort partitioner
static int __quickSortPartition(const int low, const int high) {
    flight temp;

    int i = low;
    int last = high;
    flight pivot = flightList[last];

    for (int j = low; j < high; j++) {
        if (flightList[j].distance <= pivot.distance) {
            temp = flightList[i];
            flightList[i] = flightList[j];
            flightList[j] = temp;
        }
    }

    temp = flightList[i];
    flightList[i] = flightList[high];
    flightList[high] = temp;

    return i;
}
