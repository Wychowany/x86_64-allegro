CC = gcc
CFLAGS=-Wall -m64
all: main.o func.o
	$(CC) $(CFLAGS) -o prog main.o func.o -lallegro
main.o: main.c
	$(CC) $(CFLAGS) -c -o main.o main.c 
func.o: func.s
	nasm -f elf64 -o func.o func.s
clean: 
	rm -f *.o
