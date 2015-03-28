CC=csc
OPTS=-c -O3 -d2			# Be careful, making -O5 gives segfaults!
LDFLAGS=
SRCS=parsedimacs.scm main.scm sat.scm
OBJS=parsedimacs.o main.o sat.o

all: sat

sat:
	$(CC) $(OPTS) $(SRCS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

interpret:
	csi -ss main.scm $(FILE)

clean:
	rm -rf *.o sat
