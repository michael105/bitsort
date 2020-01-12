#define DEBUG
#include <misc/debug.h>

#include <misc/list.h>

#include <stdlib.h>



int main(int argc, char **argv){

		dbg("Startup");

		dbg("argc: %s, %d",__FILE__,argc);

		int i;
		int a;
		list *l = new_list();

		for ( i=1; i<argc; i++ ){
			 dbg("%s", argv[i] );
			 a = atoi(argv[i]);
			 dbgi(a);
			 append_new_node(l,0,a);

		}

		Dump(l);

		bitsort(l,0);

		Dump(l);

		return(0);
}


