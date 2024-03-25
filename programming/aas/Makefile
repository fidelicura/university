CFLAGS ?= -Wall -Wextra -std=c99 -pedantic -Werror 

aas: main.o flight.o writer.o reader.o codificator.o
	$(CC) $(CFLAGS) -O3 -march=native -lc main.o flight.o writer.o reader.o codificator.o -o aas-release
	rm main.o flight.o writer.o reader.o codificator.o

debug: main.o flight.o writer.o reader.o codificator.o
	$(CC) $(CFLAGS) -O0 -g3 -ggdb main.o flight.o writer.o reader.o codificator.o -o aas-debug 

flight.o:
	$(CC) $(CFLAGS) -c logic/flight.c

codificator.o:
	$(CC) $(CFLAGS) -c logic/codificator.c

writer.o:
	$(CC) $(CFLAGS) -c io/writer.c

reader.o:
	$(CC) $(CFLAGS) -c io/reader.c

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

clean:
	rm aas-release aas-debug main.o flight.o writer.o reader.o codificator.o
