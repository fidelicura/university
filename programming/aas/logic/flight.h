#pragma once

typedef struct {
    int adult;
    int child;
} flightCost;

flightCost flightCostCreate(const int adult, const int child);

typedef struct {
    int hours;
    int minutes;    
} time;

time timeCreate(const int hours, const int minutes);

typedef struct {
    time start;
    time end;
} flightDuration;

flightDuration flightDurationCreate(const time start, const time end);

typedef struct {
    int id;
    const char* destination;
    double distance;
    flightCost cost;
    flightDuration duration;
} flight;

flight flightCreate(
    const int id, const double distance, const char* destination,
    const flightCost cost, const flightDuration duration
);

#define FLIGHT_LIST_AMOUNT 50
int flightListInsert(int idx, flight elem);
flight flightListGet(int idx);
int flightListLen(void);

flight flightListSortedByIdGet(int idx);
void flightListSortById(void);

flight flightListSortedByMaxGet(int idx);
void flightListSortByMax(void);

void flightChangeId(flight* obj, int value);
void flightChangeDestination(flight* obj, const char* value);
void flightChangeDistance(flight* obj, double value);
void flightChangeCost(flight* obj, flightCost value);
void flightChangeDuration(flight* obj, flightDuration value);
