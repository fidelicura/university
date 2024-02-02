CFLAGS ?= -Wall -Wextra -std=c99 -pedantic -Werror -march=native

aas: main.o
	cc $(CFLAGS) -lc main.o -o aas

main.o: main.c
	cc $(CFLAGS) -c main.c

clean:
	rm aas main.o
