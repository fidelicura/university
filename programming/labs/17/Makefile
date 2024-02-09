CFLAGS = -Wall -Wextra -std=c99 -pedantic -Werror

release: main-release.o
	$(CC) $(CFLAGS) -O3 -march=native main-release.o -o main-release

main-release.o: main.c
	$(CC) $(CFLAGS) -O3 -march=native -c main.c -o main-release.o

debug: main-debug.o
	$(CC) $(CFLAGS) -O0 -g -lc main-debug.o -o main-debug

main-debug.o: main.c
	$(CC) $(CFLAGS) -O0 -g -lc -c main.c -o main-debug.o


clean:
	rm main main.o main-release main-release.o main-debug main-debug.o
