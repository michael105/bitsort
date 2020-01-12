//#include "stllist.h"
#include <list>


using namespace std;


#define DEBUG
#include <misc/debug.h>



int main(int argc, char *argv[]){
		dbg("Start");

		list<int> *l = new list<int>;//stl_newlist();
		//fill both lists with elements

		for (int i=10; i<16; ++i) {
				l->push_back(i);
		}

		list<int>::const_iterator i;

		for ( i = l->begin(); i != l->end(); ++i ){
				dbgi(*i);
		}
		dbg("\n");

		for (int i=1; i<6; ++i) {
				l->push_back(i);
		}

		for ( i = l->begin(); i != l->end(); ++i ){
				dbgi(*i);
		}

		l->sort();
		dbg("\n");
		for ( i = l->begin(); i != l->end(); ++i ){
				dbgi(*i);
		}




		return(0);
}
