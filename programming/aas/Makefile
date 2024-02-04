CFLAGS ?= -Wall -Wextra -std=c99 -pedantic -Werror -march=native -O3 

aas: main.o flight.o writer.o reader.o
	cc $(CFLAGS) -lc main.o flight.o writer.o reader.o -o aas-release
	rm main.o flight.o writer.o reader.o

debug: main.o flight.o writer.o reader.o
	cc $(CFLAGS) main.o flight.o writer.o reader.o -o aas-debug -g 
	rm main.o flight.o writer.o reader.o

flight.o:
	cc $(CFLAGS) -c logic/flight.c

writer.o:
	cc $(CFLAGS) -c io/writer.c

reader.o:
	cc $(CFLAGS) -c io/reader.c

main.o: main.c
	cc $(CFLAGS) -c main.c

clean:
	rm aas-release aas-debug main.o flight.o writer.o reader.o
