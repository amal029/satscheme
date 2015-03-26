CC=csc
OPTS=-c -O5
LDFLAGS=
SRCS=parsedimacs.scm main.scm
OBJS=parsedimacs.o main.o

all: main

main:
	$(CC) $(OPTS) $(SRCS)
	$(CC) $(OBJS) -o $@

clean:
	rm -rf *.o main
