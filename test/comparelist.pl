#!/usr/bin/perl 
use warnings;

use Inline (C => Config =>
#FORCE_BUILD => 1,
	LIBS => '-L/usr/lib/libmisc/ -llist -lsfl');
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

use Inline (CPP => Config =>
#FORCE_BUILD => 1,
	INC => '-I/usr/lib/gcc/i686-pc-linux-gnu/4.1.2/include/g++-v4/backward/');

use Inline CPP => <<'END_OF_CPP_CODE';


// stl implementation..

#include <list>
using namespace std;

#define stlist(x) ((list<int>*)SvIV(x))

SV* STLnew_list(){ 
	list<int> *l = new list<int>();
	SV* o = newSViv(PTR2IV(l));
	return(o);
 };


void STLdestroy_list(SV* l){ 
	stlist(l)->~list<int>();
}

// copy the array to the list.
void STLarray_to_list(SV *l, AV *ar){
	int c = av_len(ar) +1;
	//printf("Count in conv: %d\n",c);
	int a = 0;

	//set_count_nodes(svlist(l), c );
	SV **k;
	//node *n = svlist(l)->first;
	for (a=0;a<c;a++ ){
		k = av_fetch(ar,a,0);
		stlist(l)->push_back( SvIV(*k) );
		//printf("loop %d %d\n", n->key, SvIV(*k) );
		//n = n->next;
	}
}

void STLclear(SV* l){
	stlist(l)->clear();
}

void STLDump(SV *l){
	printf("STLDump\n");
	list<int>::const_iterator i;
	for ( i = stlist(l)->begin(); i != stlist(l)->end(); ++i ){
		printf("%d ",*i);
	}
	printf("\n");
}

AV* STLlist_to_array(SV *l){
	AV* ar = newAV();
	av_extend(ar, stlist(l)->size() );
	int a = 0;
	list<int>::const_iterator i;
	for ( i = stlist(l)->begin(); i != stlist(l)->end(); ++i ){
		av_store(ar, a, newSViv( *i ) );
		a++;
	}

	return(ar);
}


AV* STLsort(SV *l){
	stlist(l)->sort();
	return( STLlist_to_array(l));
}

AV* STLlist_sort(SV*l, AV* ar){
	STLarray_to_list(l,ar);
	STLsort(l);
	//printf("bitsort ok.\n");
	return(STLlist_to_array(l));
}


END_OF_CPP_CODE









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
my $l2 = PLnew_list();

#SetCount(2,$l2);
#SetCount(11,$l);
print "Set.\n";

print "GetCount: ",GetCount($l),"\n";
print "GetCount: ",GetCount($l2),"\n";

my $n = PLappend_new_node($l,13);
PLappend_new_node($l,21);
PLappend_new_node($l,2);
PLappend_new_node($l,28);
for ( 17,4,9 ){
	PLappend_new_node($l,$_);
}

PLDump($l);

PLensure_count_nodes($l, 10 );
PLDump($l);

PLset_count_nodes($l,7);
PLDump($l);
PLset_count_nodes($l,12);

PLDump($l);

PLbitsort($l,0);
PLDump($l);


PLarray_to_list( $l, [12,3,4,89,34,1,7] );

PLDump($l);
PLbitsort($l,0);
PLDump($l);

foreach ( @{PLlist_to_array( $l )} ){
	print "Got: $_\n";
}

#PLdestroy_list($l);
PLdestroy_list($l2);


print "STLList..\n";
my $stl = STLnew_list();
STLarray_to_list( $stl, [12,3,4,89,34,1,7] );

STLDump($stl);
print "Sorting..\n";
foreach( @{STLsort($stl)} ){
	print "$_ ";
}
print "Ok\n";
STLDump($stl);
STLdestroy_list($stl);

$stl = STLnew_list();
STLarray_to_list( $stl, [1,14,2,90,44,23,65] );

STLDump($stl);
print "Sorting..\n";
foreach( @{STLsort($stl)} ){
	print "$_ ";
}
print "Ok\n";
STLDump($stl);
STLclear($stl);
STLDump($stl);
STLdestroy_list($stl);



$stl = STLnew_list();


#$l = PLnew_list();


#__DATA__

sub qcomp1{
	my $p = shift;
	my @ret;
	foreach (@_){
		push @ret, $_ if ( $_<$p );
	}
	return @ret;
}

sub qcomp2{
	my $p = shift;
	my @ret;
	foreach (@_){
		push @ret, $_ if ( $_>=$p );
	}
	return @ret;
}



sub qsort {
	#$rec++;
		$heap = $heap + scalar(@_);
		@_ or return ();
		#print join(" ",@_),"\n";
		my $p = shift;
		#print "XXX\n";
		$c = $c + scalar(@_) *2 ;
		# zum vergleichen ausbremsen..
		#(qsort( qcomp1($p, @_) ), $p, qsort(qcomp2($p, @_)));
		(qsort( grep( $_ < $p, @_)  ), $p, qsort(grep($_ >= $p, @_)));
}


use sort '_mergesort'; 

use Time::HiRes qw( usleep ualarm gettimeofday tv_interval nanosleep
                       clock_gettime clock_getres  );

my $t = 0;
my $t2 = 0;


use Benchmark qw(:all);
#for ( 1..20){
#for my $n( 10,20,30,50,100,200,500,1000,10000 ){
for my $n( 50, 500,1000,5000 ){
#for my $n( 4,6,8,10,16,20,30,40,50 ){
	for my $max( 4,16,50,100,200,1000,10000 ){ # bei 4 heapüberlauf bei qsort.
	#for my $max( 16,25,50,100,200 ){ # bei 4 heapüberlauf bei qsort.
		#for my $max( 16,25,50,100,200,1000,10000 ){ # bei 4 heapüberlauf bei qsort.
	my @list;
	for ( 0..$n ){
		push @list, int(rand($max));
	}
	my @a;
	#@l = @list;
	print "Count: $n    Max: $max\n";
#	print join(" ",@list),"\n";
	prove("list_bitsort", \@list, PLlist_bitsort($l,\@list) );
	prove("stl_sort", \@list, STLlist_sort($stl,\@list) );
	STLclear($stl);
	print "Sorted list.\n\n";
#	prove("list_bitsort2", \@list, PLlist_bitsort2($l,\@list) );
	#prove("list_bitsort", \@list, bitsort::bitsort(@list) );
#	@a = sort @list;
	#prove("sort", \@list, sort {$a<=>$b} @list  );
	print "Sorted.\n";

	for ( 0..500 ){
	PLarray_to_list($l,\@list);
	my $t0 =  [gettimeofday];
	PLbitsort($l,0);
	$t += tv_interval ( $t0 );
	#print "bitsort1 ok\n";
#	PLarray_to_list($l,\@list);
	STLarray_to_list($stl,\@list);
	$t0 =  [gettimeofday];
#	PLbitsort2($l,0);
	STLsort($stl);
	$t2 += tv_interval ( $t0 );
	STLclear($stl);
	#print "bitsort2 ok\n";
	}

	print "Sorted, t: $t,   t2: $t2\n";
	#timethese( 500, {list_bitsort=>sub{PLlist_bitsort($l,\@list)}, list_bitsort2=>sub{PLlist_bitsort2($l,\@list)} } );
	#timethese( 500, {qsort=>sub{@a = sort {$a<=>$b} (@list)}, list_bitsort=>sub{PLlist_bitsort($l,\@list)} } );
	#timethese( 50, {qsort=>sub{qsort(@list)}, bitsort=>sub{bitsort::bitsort(@list)}, list_bitsort=>sub{PLlist_bitsort($l,\@list)} } );
	#timethese( 10, {qsort=>sub{qsort(@list)}, movesort=>sub{movesort(@list)}, bitsort=>sub{bitsort::bitsort(@list)}} );
	#print join(" -",@list),"\n";
	#print join(" X ",bitsort::bitsort(@list)),"\n";
	#timethese( 50, {qsort=>sub{qsort(@list)},  bitsort=>sub{bitsort::bitsort(@list)}} );
}
}; 

exit 0;




