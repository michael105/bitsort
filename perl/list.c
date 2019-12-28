#include "list.h"

#include <stdlib.h>
#include <stdio.h>

// gcc -shared -fpic -o liblist.so list.c

#define DBG printf("%d \n",__LINE__);
#define swap(x,y) int t=x->key; x->key = y->key; y->key = t;

/// Create a new list
list* new_list(){
		list *l = malloc(sizeof(list));
		l->count=0;
		l->first=0;
		l->last=0;
		printf("Create list\n");
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
				n->lst = l;
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
		n->lst = Lst;
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
void remove_node(node* n){
		if(n->prev){
				n->prev->next = n->next;
		} else {
				n->lst->first = n->next;
		}
		if(n->next){
				n->next->prev = n->prev;
		} else {
				n->lst->last = n->prev;
		}
		n->lst->count--;
		n->prev=0;
		n->next=0;
}

/// Savely delete node (call remove before destroy)
void delete_node(node* n){
		remove_node(n);
		destroy_node(n);
}


/// swap to nodes
void swap_nodes(node* n1, node* n2){
		void *p = n1->object;
		n1->object = n2->object;
		n2->object = p;
}

/// sort
/// If maxkey is 0, the maximum value is determined 
void bitsort(list *l, int maxkey ){
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
				dobitsort(l->first,l->last,bits);
		}
		//	return(@l);
		//Dump(l);
}


void dobitsort(register node *le, register node *ri, register int b){
	/*	if ( le->next == ri ){
				if ( le->key > ri->key ){
						swap(le,ri);
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
			//	Dump(le->lst);
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
													goto start;
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
							swap(le,ri);
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


void dobitsort2(node *le, node *ri, int b){
/*		if ( le->next == ri ){
				if ( le->key > ri->key ){
						swap(le,ri);
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
								swap(le,ri);
						}  else { 
								b=b>>1;
								if ( b ){
								if ( ri->prev){
								//ri = ri->prev;
								//goto label;

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


 		//	label:;
			b = b>>1;
			if ( b ){
					if ( (s != ri) && (ri->next!=s) ){
							dobitsort2(s,ri,b); 
					}

					if ( ri->next && (ri->next!= e) && (ri!=e)){
							dobitsort2(ri->next,e,b); 
					}
			}
}


