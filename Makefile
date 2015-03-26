CC=csc
OPTS=-c -O5
SRCS=parsedimacs.scm main.scm
OBJS=$(SRCS:.scm=.o)

all: $(SRCS) $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@
.scm.o:
	$(CC) $(OPTS) $< -o $@

clean:
	rm -rf *.o
