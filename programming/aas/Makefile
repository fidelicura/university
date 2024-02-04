CFLAGS ?= -Wall -Wextra -std=c99 -pedantic -Werror 

aas: main.o flight.o writer.o reader.o
	$(CC) $(CFLAGS) -O3 -march=native -lc main.o flight.o writer.o reader.o -o aas-release
	rm main.o flight.o writer.o reader.o

debug: main.o flight.o writer.o reader.o
	$(CC) $(CFLAGS) -O0 main.o flight.o writer.o reader.o -o aas-debug -g 
	rm main.o flight.o writer.o reader.o

flight.o:
	$(CC) $(CFLAGS) -c logic/flight.c

writer.o:
	$(CC) $(CFLAGS) -c io/writer.c

reader.o:
	$(CC) $(CFLAGS) -c io/reader.c

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

clean:
	rm aas-release aas-debug main.o flight.o writer.o reader.o
