
SQUIRREL = ../SQUIRREL3
SQCLI = ../sqcli

CC = cc
LD = c++
CFLAGS = -Wall -Werror -Os -I$(SQUIRREL)/include
LDFLAGS = -L$(SQUIRREL)/lib
LIBS = -lsquirrel

EXT_OBJS = sqnet.o anet.o 
EXT_INCLUDE = sqnet.h
EXT_REGISTER_FUNC = register_sqnet
EXT = -DEXT_INCLUDE="\"$(EXT_INCLUDE)\"" -DEXT_REGISTER_FUNC=$(EXT_REGISTER_FUNC) -I.

CLI = cli
CLI_OBJS = cli.o linenoise.o sds.o list.o

STDEXT = -DSTDBLOB -DSTDSYSTEM -DSTDIO -DSTDMATH -DSTDSTRING -DSTDAUX
STDEXTLIB = -lsqstdlib

DEBUG ?= -O0 -g

all: $(CLI)

$(CLI): $(CLI_OBJS) $(EXT_OBJS)
	$(LD) $(LDFLAGS) $(DEBUG) -o $(CLI) $(CLI_OBJS) $(LIBS) $(STDEXTLIB) $(EXT_OBJS)

# Extension objects
sqnet.o: sqnet.c
	$(CC) -c $(CFLAGS) sqnet.c

anet.o: anet.c
	$(CC) -c $(CFLAGS) anet.c

# CLI objects
cli.o: $(SQCLI)/cli.c
	$(CC) -c $(CFLAGS) -I$(SQCLI) $(STDEXT) $(EXT) $(SQCLI)/cli.c

linenoise.o: $(SQCLI)/linenoise.c
	$(CC) -c $(CFLAGS) -I$(SQCLI) $(SQCLI)/linenoise.c

sds.o: $(SQCLI)/sds.c
	$(CC) -c $(CFLAGS) -I$(SQCLI) $(SQCLI)/sds.c

list.o: $(SQCLI)/list.c
	$(CC) -c $(CFLAGS) -I$(SQCLI) $(SQCLI)/list.c

# Generic build targets
.c.o:
	$(CC) -c $(CFLAGS) $(STDEXT) $(DEBUG) $<

.cpp.o:
	$(CC) -c $(CFLAGS) $(STDEXT) $(DEBUG) $<

dep:
	$(CC) -MM $(CFLAGS) *.c

clean:
	rm -rf $(CLI) $(LIB) *.o *~
