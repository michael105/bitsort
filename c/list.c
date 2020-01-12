#include "list.h"

#include <stdlib.h>
#include <stdio.h>

// gcc -O2 -shared -fpic -o liblist.so list.c
// gcc -mfpmath=sse -msse3 -march=athlon64 -Wall -O2 -shared -fpic -o ../liblist.so ../list.c
// (-g for debug symbols)

// 
// TODO: Konstruktor / Destruktor via Macros
// 		Listtypeprefix via Macro. (allow multiple lists with different keys/types
// 		define stored object via Macro (so the stored datatype can get returned/also e.g. a char can get stored)

#define DBG printf("%d \n",__LINE__);
#define SWAP(a, b) (((a->key) ^= (b->key)), ((b->key) ^= (a->key)), ((a->key) ^= (b->key)))
#define SWAP2(x,y) int t=x->key; x->key = y->key; y->key = t;

/// Create a new list
list* new_list(){
		list *l = malloc(sizeof(list));
		l->count=0;
		l->first=0;
		l->last=0;
		printf("Create list. sizeof node: %d\n", sizeof(node));
		return(l);
}

/// Destroy the list.
void destroy_list(list* l){
		printf("Destroy list\n");
		node* n = l->first;
		node* next;
		while (n){
				next = n->next;
				printf("Destroying Node with key %d\n",n->key);
				destroy_node(n);
				n = next;
		}

		free(l);
		printf("Destroyed\n");
}


// ensures count (empty) nodes. doesn't delete more nodes.
void ensure_count_nodes(list *l, int count){
		if ( count <= l->count )
				return;
		node *n = append_new_node(l,0,0); // ensure at least one node, and get a pointer to the last node..
//		node *ne;
		int a = count - l->count;
		while ( a>0 ){
				n->next = malloc(sizeof( node) );
				n->next->prev = n;
				n = n->next;
				//n->lst = l;
				n->key=0;
				n->object=0;
				a--;
		}
		l->count = count;
		l->last = n;
		n->next = 0;
}

// Enlarges or shrinks the list to match exactly count elements
void set_count_nodes(list *l, int count){
		//printf("set_count_nodes: prev: %d,  count: %d\n",l->count, count);
		if ( count == l->count )
				return;
		if ( count > l->count ){DBG
				ensure_count_nodes(l, count);
				return;
		}
		int a = l->count - count;
		node *n = l->last;
		while ( a>1 ){
				n = n->prev;
				destroy_node(n->next);
				a--;
		}
		if ( n->prev ){ // not the last element
				n = n->prev;
				destroy_node(n->next); DBG
				n->next=0;
		} else {
				destroy_node(n);
				n = 0; DBG
				l->first = 0;
		}
		l->last = n;
		l->count = count;
}




/// Create and append a new node
node* append_new_node(list* l, void* object, int key){
		return( (node*)new_node(l, object, l->last, 0, key) );
}

/// Iterate Over the nodes
node* next_node(node* current){
		return (current->next);
}

/// Fetch the first element
node* first_node(list *l){
		return(l->first);
}

void Dump(list *l){
		printf("Dump list. expecting %d elements.\n",l->count);
		node *n = l->first;
		while(n){
				printf("%d ",n->key);
				n = n->next;
		}
		printf("\n\n");
/*		n = l->last;
		while(n){
				printf("%d ",n->key);
				n = n->prev;
		}
		printf("\n\n");
*/
}


// Create a new node.
node* new_node( 
				list* Lst,
				void* Object, 
				node* Prev, 
				node* Next, 
				int Key ){
		node *n = malloc(sizeof( node) );
		//n->lst = Lst;
		Lst->count++;
		n->object = Object;
		n->prev=Prev;
		if(Prev){
				Prev->next = n;
				if ( Prev == Lst->last )
						Lst->last = n;
		}
		n->next=Next;
		if ( Next ){
				Next->prev = n;
		}
//		n->parent = Parent;
		if ( Lst->first == 0 )
				Lst->first = n;
		if ( Lst->last == 0 )
				Lst->last = n;

		n->key = Key;
		return(n);
}

/// destroy a node, doesn't watch the list state.
void destroy_node(node* node){
		free(node);
}


/// remove the node of the node's list, keep the list intact
void remove_node(list* lst, node* n){
		if(n->prev){
				n->prev->next = n->next;
		} else {
				lst->first = n->next;
		}
		if(n->next){
				n->next->prev = n->prev;
		} else {
				lst->last = n->prev;
		}
		lst->count--;
		n->prev=0;
		n->next=0;
}

/// Savely delete node (call remove before destroy)
void delete_node(list* lst, node* n){
		remove_node(lst, n);
		destroy_node(n);
}


#define CALL_BITSORT dobitsort(s,ri,b);
#define RET return;

static int dobitsort (register node *le, register node *ri, register int b) {
		register node *e = ri;
		//register char stack = 0;
		register node *s;
		//do {
start:;
			s = le;
			//inlined:
			//do {
loop1:
			if ( le->key & b ){
					while ( ri->key & b ){
							//loop2:
							//if ( !(ri->key & b) )
							//	break;
							//goto loop2out;
							ri = ri->prev;
							if (le!=ri){
									continue;
							} 
							if(__builtin_expect((b>>=1),1)){
									if ( ri->prev ){
											ri=ri->prev;
											goto label;
									}

									if (__builtin_expect(ri!=e,1)){
											//le=ri;
											ri=e;
											goto start;
									}
							}
							RET
									//return;
					}
					//loop2out:
					SWAP2(le,ri);
			} 
			//} while ( (le=le->next) && (le!=ri));
			le=le->next;
			//if ( (le=le->next) && (le!=ri))
			if ( le!=ri )
					goto loop1;

			if ( ri->key & b ){
					ri=ri->prev;
			}
			if ( (b>>=1) ){
label:
					if ( (s != ri) && (ri->next!=s) ){
							CALL_BITSORT
									//dobitsort(s,ri,b); 
					}
					//ret:

					if ( ri->next && (ri->next!= e) && (ri!=e)){
							//dobitsort(ri->next,e,b); 
							le=ri->next;
							ri=e;
							goto start;
					}
					//le=ri->next;
					//ri=e;
			} 
				
//		} while ( b && (ri!=e) && (le=ri->next) && (ri=e) );
			RET
}

//
int bitsort(list *l, register int maxkey ){
		if ( !maxkey ){
				node *n = l->first;
				while(n){
						if ( maxkey < n->key )
								maxkey = n->key;
						n = n->next;
				}
				//printf("max: %d\n", maxkey);
		}
		if ( !maxkey )
				return(0);

/*		int b = 0;
		while ( maxkey ){
				maxkey = maxkey >> 1;
				b++;
		}
		int bits = 1<<b;*/
/*		register int bits = 2;

		asm volatile ("bsr %1, %%ecx\n\t"
						//"mov $2, %0\n\t"
						//"bts %%ecx, %0\n\t"
						"shl %%cl, %0"
						: "=r" (bits)
						: "r" (maxkey), "0" (bits)
						: "%ecx"
						);
						*/

		register int bits = 0xFFFFFFFE;
		//register int bits = UINT32_MAX -1;
		while ( maxkey & bits ){
				bits <<= 1;
		}
		bits = ~bits;
		bits++;
		//printf("bits: %u\n", bits);

		return(dobitsort(l->first,l->last,bits));
}
















static void old_dobitsort(node *le, node *ri, int b);
/// sort
/// If maxkey is 0, the maximum value is determined 
void old_bitsort(list *l, int maxkey ){
		if ( l->count < 2 )
				return;
		if ( maxkey == 0 ){
				node *n = l->first;
				while(n){
						maxkey = maxkey | n->key;   
						//if ( maxkey < n->key ) // maxkey = maxkey | n-> key    ...   maxkey ++; bits = maxkey >> 1;
						//		maxkey = n->key;
						n = n->next;
				}
				//maxkey++; 
				//bits = maxkey;
		} 
		if ( maxkey==0 )
				return;


		/* int bits = maxkey;
		bits |= (bits >> 1);
		bits |= (bits >> 2);
		bits |= (bits >> 4);
		bits |= (bits >> 8);
		bits |= (bits >> 16);
		bits = (bits &(~(bits >> 1))) << 1;
		printf("bits shifted bitsort: %d\n", bits);
*/
			
		int bits = ~1;
	  maxkey &= bits;
		while ( maxkey ){
				bits = bits << 1;
				maxkey &= bits;
		}
		bits = ~bits;
		bits++;
		
		//printf("bits bitsort: %d\n", bits);
		



		if ( bits ){
				dobitsort(l->first,l->last,bits);
		}
//		printf("Ok : list.c..\n");
		//	return(@l);
		//Dump(l);
}

#define _RET if ( __builtin_expect(stack,1) ){\
					stack--;\
					asm( "pop %2\n\tpop %1\n\tpop %0" : "=r" (b), "=r" (e), "=r" (ri) );\
					goto ret;\
			} \
			return;

#define RET return;

#define _CALL_BITSORT stack++;\
					asm( "push %0\n\tpush %1\n\tpush %2" :: "r" (b), "r" (e), "r" (ri) );\
					le=s;\
					e=ri;\
					goto inlined;


#define CALL_BITSORT dobitsort(s,ri,b);

static void old_dobitsort (register node *le, register node *ri, register int b) {
		register node *e = ri;
		//register char stack = 0;
		register node *s;
start:;
			s = le;
//inlined:
			//	Dump(le->lst);
			//	printf("dobitsort b: %d  le: %d     ri: %d\n",b, le->key, ri->key ); 
			//do {
			loop1:
					if ( le->key & b ){
							__builtin_prefetch(ri->prev);
							while ( ri->key & b ){
								//loop2:
									//if ( !(ri->key & b) )
										//	break;
										//goto loop2out;

									ri = ri->prev;
									__builtin_prefetch(ri->prev);
									if (le!=ri){
											continue;
									}
											//goto loop2;
									if(__builtin_expect((b>>=1),1))
											//if ( b )
											{	
													if ( ri->prev ){
															ri=ri->prev;
															goto label;
													}
													if (__builtin_expect(ri!=e,1)){
															//le=ri;
															ri=e;
															goto start;
													}
											}
											RET
											//return;
									
							}
								//loop2out:
							SWAP(le,ri);
					} 

			//} while ( (le=le->next) && (le!=ri));
			if ( (le=le->next) && (le!=ri))
					goto loop1;

			if ( ri->key & b ){
					ri=ri->prev;
			}

			//b = b>>1;
			if ( (b>>=1) ){
label:;
			if ( (s != ri) && (ri->next!=s) ){
					CALL_BITSORT
					//dobitsort(s,ri,b); 
			}
//ret:


			if ( ri->next && (ri->next!= e) && (ri!=e)){
					//dobitsort(ri->next,e,b); 
					le=ri->next;
					ri=e;
					goto start;
			}
			}

			RET
}



#if 0
					//UNROLL *************************
					int b2 = b;
					//node* le2 = le;
					node* ri2 = ri;
					node* e2 = e;
					//node* s2 = s;
					le=s;

		e = ri;
start2:;
//			s = le;
			//			Dump(le->lst);
			//	printf("dobitsort b: %d  le: %d     ri: %d\n",b, le->key, ri->key ); 
			//do {
			loop12:
					if ( le->key & b ){
							while ( ri->key & b ){
								//loop2:
									//if ( !(ri->key & b) )
										//	break;
										//goto loop2out;

									ri = ri->prev;
									if (le!=ri)
											continue;
											//goto loop2;
									if(b>>=1)
											//if ( b )
											{	
													if ( ri->prev ){
															ri=ri->prev;
															goto label2;
													}
													if (ri!=e){
															s=le=ri;
															ri=e;
															//b=b>>1;
															//if ( b )
															goto start2;
															// else return
													}
											}
											goto ret2;
											// return;
									
							}
								//loop2out:
							SWAP(le,ri);
					} 

			//} while ( (le=le->next) && (le!=ri));
			if ( (le=le->next) && (le!=ri))
					goto loop12;

			if ( ri->key & b ){
					ri=ri->prev;
			}

			//b = b>>1;
			if ( (b>>=1) ){
label2:;
			if ( (s != ri) && (ri->next!=s) ){
					/*		stle[pstack] = s;
								stri[pstack] = ri;
								bit[pstack] = b;
								pstack++;*/

					dobitsort(s,ri,b); 
			}

			if ( ri->next && (ri->next!= e) && (ri!=e)){
					//dobitsort(ri->next,e,b); 
					s=le=ri->next;
					ri=e;
					goto start2;
			}
			}

ret2:
			e = e2;
			ri=ri2;
			//le=le2;
			b=b2;
			//s=s2;

			//UNROLL ***

#endif


/// sort
/// If maxkey is 0, the maximum value is determined 
void bitsort2(list *l, int maxkey ){
		if ( maxkey == 0 ){
				node *n = l->first;
				while(n){
						if ( maxkey < n->key )
								maxkey = n->key;
						n = n->next;
				}
				//printf("max: %d\n", maxkey);
		}
		int b = 0;
		while ( maxkey ){
				maxkey = maxkey >> 1;
				b++;
		}
		int bits = 1<<b;
		//$bits = 2**$bits;
		//printf("bits: %d\n", bits);

		if ( bits ){
				dobitsort2(l->first,l->last,bits);
		}
		//	return(@l);
		//Dump(l);
}


void dobitsort2(register node *le, register node *ri, register int b){
	/*	if ( le->next == ri ){
				if ( le->key > ri->key ){
						SWAP(le,ri);
				}
				return;
		}*/
/*		node* stle[32];
		node* stri[32];
		int bit[32];
		int pstack = 0;
		goto l2;

pop:
//		printf("pstack: %d\n",pstack);
		pstack--;
		le=stle[pstack];
		ri=stri[pstack];
		b=bit[pstack];
l2:;*/
		register node *e = ri;
start:;
			register node *s = le;
//			Dump(le->lst);
//	printf("dobitsort b: %d  le: %d     ri: %d\n",b, le->key, ri->key ); 
			do {
					if ( le->key & b ){
							while ( ri->key & b ){
									ri = ri->prev;
									if (le==ri) { 
											if ( ri->prev ){
													ri=ri->prev;
													goto label;
											}
											if (ri!=e){
													le=ri;
													ri=e;
													b=b>>1;
													if ( b )
															goto start;
													// else return
											}
											//return;
											/*
											b=b>>1;
											if ( b ){
													if ( ri->prev  && (ri->prev!=s) && (s!=ri)){
															//ri = ri->prev;
															//goto label;
															//dobitsort(s,ri->prev,b);
															stle[pstack] = s;
															stri[pstack] = ri->prev;
															bit[pstack] = b;
															pstack++;

													}
													if ( ( ri!=e ) ){
															le = ri;
															ri = e;
															goto start;
															//dobitsort(ri,e,b);
													}
											}*/
										/*	if (pstack ) 
													goto pop;
											else*/
													return;
									}
							}
							SWAP2(le,ri);
					} 
					//le = le->next;

			} while ( (le=le->next) && (le!=ri));

			if ( ri->key & b ){
					ri=ri->prev;
			}

	label:;
			b = b>>1;
			if ( b ){
					if ( (s != ri) && (ri->next!=s) ){
			/*		stle[pstack] = s;
					stri[pstack] = ri;
					bit[pstack] = b;
					pstack++;*/

							dobitsort(s,ri,b); 
					}

					if ( ri->next && (ri->next!= e) && (ri!=e)){
							//dobitsort(ri->next,e,b); 
							le=ri->next;
							ri=e;
							goto start;
					}
			}

//			if (pstack ) 
	//				goto pop;
}





#ifdef NEVER

void dobitsort2(node *le, node *ri, int b){
/*		if ( le->next == ri ){
				if ( le->key > ri->key ){
						SWAP(le,ri);
				}
				return;
		}*/
		node *s = le;
		node *e = ri;
	//	Dump(le->lst);
	//	printf("dobitsort b: %d  le: %d     ri: %d\n",b, le->key, ri->key ); 
 do {
				if ( le->key & b ){
						while ( (ri->key & b) && (le != ri) ){
								ri = ri->prev;
						}
						if ( le!=ri){
								SWAP2(le,ri);
						}  else { 
								b=b>>1;
								if ( b ){
								if ( ri->prev){
								ri = ri->prev;
								goto label;

										dobitsort2(s,ri->prev,b);
								}
								if (  ri!=e  ){
										dobitsort2(ri,e,b);
								}
								return;
								}

				
						}

				} 
				le = le->next;

		} while ( le && (le!=ri));
// label1:; 
		if ( ri->key & b ){
				ri=ri->prev;
		}


			b = b>>1;
 			label:;
			if ( b ){
					if ( (s != ri) && (ri->next!=s) ){
							dobitsort2(s,ri,b); 
					}

					if ( ri->next && (ri->next!= e) && (ri!=e)){
							dobitsort2(ri->next,e,b); 
					}
			}
}

#endif

