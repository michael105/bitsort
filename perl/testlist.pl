#!/usr/bin/perl 
use warnings;

use Inline (C => Config =>
FORCE_BUILD => 1,
	LIBS => '-L/home/micha/prog/perl/test/sort_algorithms/ -llist',);
#use Inline C =>q{struct node* new_node(void* Object, struct node* Prev, struct node* Next, int Key );};
#use Inline C =>q{struct list* new_list( );};

use Inline C => <<'END_OF_C_CODE';
#include "list.h"

SV* PLnew_list(){ 
SV* obj_ref = newSViv(0);
struct list *l = new_list();
SV* obj = sv_setref_pv(obj_ref, "list", l);
//sv_setiv((SV*)l, (SV*)l)
return(obj_ref);
 };

void PLdestroy_list(SV* l){ 
destroy_list((struct list*)SvIV(SvRV(l)));
sv_unref(l);
};

void SetCount(int Key, SV*l ){
	((struct list*)SvIV(SvRV(l)))->count = Key;
}

int GetCount(SV*l){
	return(((struct list*)SvIV(SvRV(l)))->count);
}





END_OF_C_CODE




sub prove{
#	print "p:  ",join(" ",@_),"\n";
	my $s = shift;
	my $l = shift;
	my $p = shift;
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


{
my $l = PLnew_list();
my $l2 = PLnew_list();

SetCount(2,$l2);
SetCount(11,$l);
print "Set.\n";

print "GetCount: ",GetCount($l),"\n";
print "GetCount: ",GetCount($l2),"\n";


PLdestroy_list($l);
PLdestroy_list($l2);

}

