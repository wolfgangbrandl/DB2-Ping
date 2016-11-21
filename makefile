CC              =       /usr/bin/g++
CC2             =       /usr/bin/gcc
DATASOURCE      =       SAMPLE
DBUSER          =       db2admin
DBPWD            =       first
DB2INSTANCEPATH =       /home/$(DB2INSTANCE)
#CFLAGS          =       -g -pedantic -Wall -DVERSION1
CFLAGS          =       -g 
LIBDIR          =       -L$(DB2INSTANCEPATH)/sqllib/lib -ldb2
INCLUDE         =       -I$(DB2INSTANCEPATH)/sqllib/include
OBJ             =       dbping.o

.SUFFIXES:  $(.SUFFIXES) .o .c .sqc
%.o:    %.c
	$(CC) $(CFLAGS) $(INCLUDE) -c $<
%.c:    %.sqc
	db2 connect to $(DATASOURCE) user $(DBUSER) using $(DBPWD)
	db2 prep $< bindfile
	db2 bind $*.bnd
	cp $@ $@.tmp


all : dbping
bind:
	db2 connect to $(DATASOURCE) user $(DBUSER) using $(DBPWD)
	db2 bind qmap.bnd QUALIFIER BSAX COLLECTION GEOS
	db2 terminate

dbping:        dbping.o
	$(CC2) $(CFLAGS) $(LIBDIR) -o dbping $<


clean:
	rm -f *.c.c *.i *.o *.bnd *.tmp $(OBJ) qmap.c 

