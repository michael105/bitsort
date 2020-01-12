#include <stdio.h>
#include "udb/benchmark.h"

#include "tree.h"


int test_int(int N, const unsigned *data)
{
	int i, ret,k;
	tree *t = new_tree();
	dbg_tree = t;
	set_max(t,0xefffffff);
	tnode *n,**p;
	void *v;

	int c = 0;
	for (i = 0; i < N; ++i) {
			c++;
			if ( c > 100000 ){
					printf("Iterations: %u\nCurrent: %u\n",i,data[i]);
					print_counters();
					reset_counters();
					c = 0;
					int b = checkorderdepth(t->root,0);
					printf ("Max depth( checkorderdepth ): %u\n",b);
			}
		k = data[i];
		if (find_leaf(&n,&p,t->root,k)== 0 ) new_leaf(t,k,v);
		else {
				//delete_leaf(t,k);
		}
	}
					printf("Iterations: %u\nCurrent: %u\n",i,data[i]);
					print_counters();
					reset_counters();
					c = 0;
					int b = checkorderdepth(t->root,0);
					printf ("Max depth( checkorderdepth ): %u\n",b);

		printtree2(t->root,0,'T',t->root);
	ret = 1;
#if 0
	if (0) {
		unsigned xor = 0;
#define traf(k) (xor ^= (k)->value)
		__kb_traverse(intmap_t, h, traf);
		printf("%u\n", xor);
	}
	//kb_destroy(int, h);
#endif
	return ret;
}

int test_str(int N, char * const *data){
		return(0);
}

int main(int argc, char *argv[])
{
	return udb_benchmark(argc, argv, test_int, test_str);
}
