#include "list.h"

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include <stdint.h>

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

#define starttm(T) gettimeofday(&__TVBeg_##T, NULL)

#define endtm(T,D)                                                      \
{                                                                       \
	gettimeofday(&__TVEnd_##T, NULL);                                   \
  (D) = (double)(__TVEnd_##T.tv_sec  - __TVBeg_##T.tv_sec) * 1E6 +    \
  			((double)(__TVEnd_##T.tv_usec - __TVBeg_##T.tv_usec));         \
}

#define addtm(T,D)                                                      \
{                                                                       \
	gettimeofday(&__TVEnd_##T, NULL);                                   \
  (D) += (double)(__TVEnd_##T.tv_sec  - __TVBeg_##T.tv_sec) * 1E6 +    \
  			((double)(__TVEnd_##T.tv_usec - __TVBeg_##T.tv_usec)) - overhead;         \
}



TIMER_vars(t);

// end judyl..

struct timeval currenttime;

int main(int argc, char **argv){

		starttm(t);

		dbg("Startup");


		int m = UINT16_MAX;
		dbgi( m );



		int i;
		int a;
		list *l = new_list();

	//	sleep(1);
		list *l1 = new_list();
		//list *l2 = new_list();

		if ( argc<4 ){
				printf("\nNeed args: count elements max...\nRepeat sorting count times..\n");
				return(1);
		}

		dbg("argc: %s, %d",__FILE__,argc);
		int count = atoi(argv[1]);
		int elements = atoi(argv[2]);
		int max = atoi(argv[3]);
		gettimeofday(&currenttime,0);
		srand(currenttime.tv_usec);

		for ( i=1; i<elements; i++ ){
			 //dbg("%s", argv[i] );
			 //a = atoi(argv[i]);
			 a = (int) (max * (rand() / (RAND_MAX + 1.0)));
//dbgi(a);
			 append_new_node(l,0,a);
			 append_new_node(l1,0,a);

		}

		//sleep(1);
		endtm(t,d);
	
		d = d/1000000;
		printf("Time needed: %f6\n",d);
		printf("count: %u, elements: %u, max: %u\n", count, elements, max);
//		return(0);


		double overhead = 0;
		starttm(t);
		endtm(t,d);
		d=0;
		for (i=0; i<=100000; i++ ){
				starttm(t);
				addtm(t,d);
		}
		double e = d/1000000;
		overhead = d/100000;
				
		printf("Calibrating: %f6\n",e);



		//Dump(l);

		printf("Starting..\n");
		//usleep(50000);

		node *n; 
		node *n1; 

		printf("bitsort:\n");
		
		d = 0;

		int countmain;
		for ( a=0; a<count; a++ ){

				starttm(t);
				countmain = bitsort(l1,0);
				addtm(t,d);

				n	= l->first;
				n1	= l1->first;
				while ( n ){
				//		printf("%u  ", n1->key);
						n1->key = n->key;
						n = n->next;
						n1 = n1->next;
				}
			//	printf("\n");

		}

		//endtm(t,d);
		d = d/1000000;
		printf("Time needed: %f6\n",d);

		printf("bitsort2:\n");
		

		int count2 = 0;
		d=0;

		for ( a=0; a<count; a++ ){

				starttm(t);
				bitsort2(l1,0);
				addtm(t,d);

				n	= l->first;
				n1	= l1->first;
				while ( n ){
						n1->key = n->key;
						n = n->next;
						n1 = n1->next;
				}

		}

		//endtm(t,d);
		d = d/1000000;
		printf("Time needed: %f6\n",d);


		//Dump(l);
		//sleep(3);

		//nt countthread = exit_worker_threads();
		//printf("Mainloops: %u\nThreadloop: %u\n", countmain, countthread);
		//printf("bitsort2loops: %u\n", count2);

		//dbg("thread exit");

		//sleep(1);

		return(0);
}


