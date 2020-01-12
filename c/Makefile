tree: tree.c minilib.o compile
	gcc -g -Wall -o tree minilib.o tree.c -Dstandalone


minilib.o: minilib.h minilib.c
	gcc -c -o minilib.o minilib.c


testlist: testlist.c list.c compile
	gcc -O2 -o testlist testlist.c list.c -lmisc/libdebug



treecmp: treecmp.c list.c tree.o list.h tree.h
	gcc -O2 -o treecmp tree.o treecmp.c list.c -lmisc/libdebug

tree.o: tree.c tree.h compile
	gcc -g -O2 -c -o tree.o tree.c


benchmarktree: benchmarktree.c tree.o tree.h compile
	gcc -g -O2 -o benchmarktree benchmarktree.c tree.o udb/benchmark.o udb/runlib.o


