#!/usr/bin/perl 
use warnings;

use Inline (C => Config =>
#FORCE_BUILD => 1,
	LIBS => '-L/usr/lib/libmisc/ -llist');
#use Inline C =>q{struct node* new_node(void* Object, struct node* Prev, struct node* Next, int Key );};
#use Inline C =>q{struct list* new_list( );};

use Inline C => <<'END_OF_C_CODE';
#include <misc/list.h>


#define svlist(x) ((list*)SvIV(x))

SV* PLnew_list(){ 
SV* o = newSViv(PTR2IV(new_list()));
return(o);
 };

void PLdestroy_list(SV* l){ 
destroy_list((list*)SvIV(l) );
printf("Pldestroy_list Ok\n");
};

void SetCount(int Key, SV*l ){
	((list*)SvIV(l))->count = Key;
}

int GetCount(SV*l){
	return(((list*)SvIV(l))->count);
return(0);
}

SV* PLappend_new_node(SV* l, int key){
	SV *o = newSViv(PTR2IV( append_new_node( (list*)SvIV(l),0,key )));
	return(o);
}

void PLDump(SV *l){
	Dump((list*)SvIV(l));
}

void PLbitsort(SV *l, int maxkey){
	bitsort( svlist(l), maxkey );
}
void PLbitsort2(SV *l, int maxkey){
	bitsort2( svlist(l), maxkey );
}


void PLensure_count_nodes(SV *l, int count){
	ensure_count_nodes(svlist(l), count);
}

void PLset_count_nodes(SV *l, int count){
	set_count_nodes(svlist(l), count);
}


// copy the array to the list.
void PLarray_to_list(SV *l, AV *ar){
	int c = av_len(ar) +1;
	//printf("Count in conv: %d\n",c);
	int a = 0;

	set_count_nodes(svlist(l), c );
	SV **k;
	node *n = svlist(l)->first;
	for (a=0;a<c;a++ ){
		k = av_fetch(ar,a,0);
		n->key = SvIV(*k);
		//printf("loop %d %d\n", n->key, SvIV(*k) );
		n = n->next;
	}
}

	
AV* PLlist_to_array(SV *l){
	AV* ar = newAV();
	av_extend(ar, svlist(l)->count );
	node *n = svlist(l)->first;
	int a = 0;
	while ( n ){
		av_store(ar, a, newSViv( n->key ) );
		a++;
		n = n->next;
	}
	return(ar);
}

AV* PLlist_bitsort(SV*l, AV* ar){
	PLarray_to_list(l,ar);
	bitsort( svlist(l),0);
	//printf("bitsort ok.\n");
	return(PLlist_to_array(l));
}

AV* PLlist_bitsort2(SV*l, AV* ar){
	PLarray_to_list(l,ar);
	bitsort2( svlist(l),0);
	//printf("bitsort ok.\n");
	return(PLlist_to_array(l));
}



END_OF_C_CODE




sub prove{
#	print "p:  ",join(" ",@_),"\n";
	my $s = shift;
	my $l = shift;
	my $p = shift;
	if ( ref($p ) ){
		$a = $p;
		$p = shift @{$a};
		my $f = $p;
		foreach (@{$a}){
			if ( $p>$_){
				print "\n\nDIE.\n$s\n",join(" ",@{$l}),"\nxxxxxxxxxxxxxxxxxx\n$f ",join(" ",@{$a}),"\n";

				die;
			}
			$p = $_;
		}
		return(1);
	}

	my $f = $p;
	foreach (@_){
		if ( $p>$_){
			print "\n\nDIE.\n$s\n",join(" ",@{$l}),"\n$f ",join(" ",@_),"\n";

			die;
		}
		$p = $_;
	}
	return 1;
}



my $l = PLnew_list();

my @list;
open F, "<$ARGV[0]" or die;
@list = split(" ",<F>);
close F;


	print join("-",@list),"\nX\n";

	prove("list_bitsort", \@list, PLlist_bitsort($l,\@list) );
	print "Sorted list.\n\n";
#	prove("list_bitsort2", \@list, PLlist_bitsort2($l,\@list) );
	#prove("list_bitsort", \@list, bitsort::bitsort(@list) );
#	@a = sort @list;
	#prove("sort", \@list, sort {$a<=>$b} @list  );

exit 0;




