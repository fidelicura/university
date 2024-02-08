#include <stdio.h>

void binary_print(char symbol, int digit);
void hex_print(char symbol, int digit);
void float_print(int day, int month, int year);
void standartized_print(int day, int month, int year);

int main(void)
{
    int day, month, year;

    printf("\nДень рождения: ");
    scanf("%d", &day);
    printf("Месяц рождения: ");
    scanf("%d", &month);
    printf("Год рождения: ");
    scanf("%d", &year);

    printf("\n 10 система счисления");
    binary_print('D', day);

    printf(" 16 система счисления");
    hex_print('D', day);

    printf(" Вещественное X=Y.MD");
    float_print(day, month, year);

    standartized_print(day, month, year);
}

void binary_print(char symbol, int digit)
{
    printf(
        "\n %c=%i \n-%c=%i \n %c=%7i \n-%c=%7i \n %c=%07i \n-%c=%07i \n %c=%07.5i\n-%c=%07.5i\n\n",
        symbol, digit,
        symbol, -digit,
        symbol, digit,
        symbol, -digit,
        symbol, digit,
        symbol, -digit,
        symbol, digit,
        symbol, -digit
    );
}

void hex_print(char symbol, int digit)
{
    printf("\n %c=%08xd \n-%c=%08xd\n\n", symbol, digit, symbol, -digit);
}

void float_print(int day, int month, int year)
{
  double date = year + (month / 100.0) + (day / 10000.0);
  
  printf("\n X=%e\n", date);
  printf(" X=%f\n", date);
  printf(" X=%d.%02d%02d\n\n", year, month, day);
}

void standartized_print(int day, int month, int year)
{
    printf(" Дата вашего рождения (DD.MM.YYYY) - %02d.%02d.%04d г.\n", day, month, year);
    printf(" Дата вашего рождения (DD.MM.YY) - %02d.%02d.%02d г.\n", day, month, year);
}
