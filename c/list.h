#ifndef LIST_H
#define LIST_H

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _list{
		void* object;
		struct _node* first;
		struct _node* last;
		int count;
} list;

typedef struct _node{
		struct _node* next;
		struct _node* prev;
//		node** parent;
		int key;
		void* object;
//		node** first;
//		node** last;
//		list* lst;
} node;

void Dump();

list* new_list();
void destroy_list(list* l);

void ensure_count_nodes(list *l, int count);
void set_count_nodes(list *l, int count);

node* append_new_node(list* l, void* object, int key);
node* next_node(node* current);
node* first_node(list *l);

node* new_node( list *l,
				void* Object, 
				node* Prev, 
				node* Next, 
				int Key );

void destroy_node(node* node);
void remove_node(list* lst, node* n);
void delete_node(list* lst, node* n);

int bitsort(list *l, int maxkey);

void bitsort2(list *l, int maxkey);
void dobitsort2(node *le, node *ri, int b);

#ifdef __cplusplus
}
#endif

#endif

