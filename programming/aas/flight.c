typedef enum {
    Child,
    Adult,
} costTag;

typedef union {
    costTag tag;
    float child;
    float adult;
} flightCost;

typedef struct {
    float hours;
    float minutes;
} flightTime;

typedef struct {
    int number;
    double distance;
    flightCost amount;
    flightTime duration;
} flight;
