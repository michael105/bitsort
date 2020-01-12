#include "list.h"

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#define DEBUG
#include <misc/debug.h>



//from judyl..
double    d;            // Global for remembering delta times

// Note: I have found some Linux systems (2.4.18-6mdk) have bugs in the 
// gettimeofday() routine.  Sometimes the difference of two consective calls 
// returns a negative ~2840 microseconds instead of 0 or 1.  If you use the 
// above #include "timeit.h" and compile with timeit.c and use 
// -DJU_LINUX_IA32, that problem will be eliminated.  This is because for 
// delta times less than .1 sec, the hardware free running timer is used 
// instead of gettimeofday().  I have found the negative time problem
// appears about 40-50 times per second with numerous gettimeofday() calls.
// You should just ignore negative times output.

#define TIMER_vars(T) struct timeval __TVBeg_##T, __TVEnd_##T

#define STARTTm(T) gettimeofday(&__TVBeg_##T, NULL)

#define ENDTm(T,D)                                                      \
{                                                                       \
	gettimeofday(&__TVEnd_##T, NULL);                                   \
  (D) = (double)(__TVEnd_##T.tv_sec  - __TVBeg_##T.tv_sec) * 1E6 +    \
  			((double)(__TVEnd_##T.tv_usec - __TVBeg_##T.tv_usec));         \
}

TIMER_vars(t);


int main(int argc, char **argv){

		STARTTm(t);

		dbg("Startup");

		dbg("argc: %s, %d",__FILE__,argc);

		//sleep(1);
		ENDTm(t,d);
	
		d = d/1000000;
		printf("Time needed: %f6\n",d);
		//return(0);

		int i;
		int a;
		list *l = new_list();

	//	sleep(1);
		list *l1 = new_list();
		//list *l2 = new_list();

		if ( argc<1 ){
				printf("Need args: count n1 n2 n3...\nRepeat sorting n1 n2 n3 count times..\n");
				return(1);
		}
		int count = atoi(argv[1]);

		for ( i=2; i<argc; i++ ){
			 //dbg("%s", argv[i] );
			 a = atoi(argv[i]);
			 //dbgi(a);
			 append_new_node(l,0,a);
			 append_new_node(l1,0,a);

		}

		//Dump(l);

		printf("Starting..\n");
		usleep(50000);

		node *n; 
		node *n1; 

		printf("bitsort:\n");
		
		STARTTm(t);

		int countmain;

		for ( a=0; a<=count; a++ ){

				countmain = bitsort(l1,0);

				n	= l->first;
				n1	= l1->first;
				while ( n ){
						n1->key = n->key;
						n = n->next;
						n1 = n1->next;
				}

		}

		ENDTm(t,d);
		d = d/1000000;
		printf("Time needed: %f6\n",d);


		int countthread = exit_worker_threads();

		printf("Mainloops: %u\nThreadloop: %u\n", countmain, countthread);

		return(0);
}


