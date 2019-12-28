package bitsort;
use warnings;

use Benchmark qw(:all);

my @l;

sub bitsort{
	@l = @_;
	my $max = 0; 
	my $count = scalar(@l)-1;
	# könnte bei Bekanntsein des maximums auch eingespart werden..
	foreach (@l){
		$max=$_ if ( $max < $_ );
	}

	# besser aus tabelle lesen..
	#$bits = int((log($max)/log(2)) +1 );
	my $b = 1;
	while ( $max = $max >> 1 ){
		$b++;
	}
	my $bits = 1<<$b;
	#$bits = 2**$bits;
#	print "bits: $bits\n";

	if ( $count && $bits ){
			dobitsort2(0,$count,$bits);
	}
	return(@l);
}

sub cmp_bitsort{
	@l = @_;
	my @list = @l;
	my $max = 0; 
	my $count = scalar(@l)-1;
	# könnte bei Bekanntsein des maximums auch eingespart werden..
	foreach (@l){
		$max=$_ if ( $max < $_ );
	}

	# besser aus tabelle lesen..
	#$bits = int((log($max)/log(2)) +1 );
	my $b = 1;
	while ( $max = $max >> 1 ){
		$b++;
	}
	my $bits = 1<<$b;
	#$bits = 2**$bits;
#	print "bits: $bits\n";

	if ( $count && $bits ){
		#dobitsort(0,$count,$bits);
		cmpthese(20, { 
				'bitsort'=>sub{ @l = @list; dobitsort(0,$count,$bits) },
				'modified'=>sub{ @l = @list; dobitsort2(0,$count,$bits) } 
			} );
	}
	return(@l);
}


sub dobitsort2{
#	my($le,$ri,$b) = @_;

	#my $s = $le;
	#my $e = $ri;
	my ($b,$ri,$le,$s,$e);

#	my $s;
#	my $e;
#	my @stack;
#	push @stack, $le, $ri, $b;

	do { # while(@stack)
		$b = pop @_; # insgesamt in perl sogar deutlich langsamer. (sollt wiederum in C schneller funzen..
		$ri = pop @_;
		$le = pop @_;
		$s = $le;
		$e = $ri;

	do {
		if ( $l[$le] & $b ){
			while ( $l[$ri] & $b ){ #&& ($le<$ri) ){
				$ri--;
				if ( $le==$ri ){
					$ri--;
					goto label; #sollt eigentlich (in C) schneller sein, in perl nicht.
				}
			}
			#if ( $le<$ri){ 
			my $t = $l[$le]; $l[$le] = $l[$ri]; $l[$ri] = $t; #swap #print "SWAP ",$le+1," ", $ri+1,"\n";
				#} else { # optional. (ri-- und goto)
				#$ri--;
				#goto label;
				#}
		} 
		$le++;
	} while ( $le<$ri);

	label1:; 
	if ( $l[$ri] & $b ){
		$ri--;
	}

	label:;

	$b = $b>>1;
	if ( $b ){
		if ( $s < $ri ){
			#dobitsort($s,$ri,$b); 
			push @_, $s, $ri, $b;
		}
		if ( $ri+1 < $e ){
			#dobitsort($ri+1,$e,$b); 
			push @_, $ri+1, $e, $b;
		}
	}
	} while (@_);
}

sub dobitsort{
	my($le,$ri,$b) = @_;
	my $s = $le;
	my $e = $ri;

	do {
		if ( $l[$le] & $b ){
			while ( ($l[$ri] & $b) && ($le<$ri) ){
				$ri--;
			}
			if ( $le<$ri){
				my $t = $l[$le]; $l[$le] = $l[$ri]; $l[$ri] = $t; #swap #print "SWAP ",$le+1," ", $ri+1,"\n";
			} 	 #else { # optional. (ri-- und goto)
			#$ri--;
			#	goto label;
			#}

		} 
		$le++;
	} while ( $le<$ri);

	label1:; 
	if ( $l[$ri] & $b ){
		$ri--;
	}

	label:;

	$b = $b>>1;
	if ( $b ){
		if ( $s < $ri ){
			dobitsort($s,$ri,$b); 
		}
		if ( $ri+1 < $e ){
			dobitsort($ri+1,$e,$b); 
		}
	}
}



sub dobitsort_old{
	my($le,$ri,$b) = @_;
	my $s = $le;
	my $e = $ri;

	do {
		if ( $l[$le] & $b ){
			while ( $l[$ri] & $b ){
				$ri--;
				if ( $le == $ri ){ # beide auf "und bit"

					#$ri--; # oder das hier weglassen und dafür zu label1 springen
					#goto label; 

					if ( $s<$ri-1){
						dobitsort($s,$ri-1,$b>>1);
					}
					if ( $ri<$e ){
						dobitsort($ri,$e,$b>>1);
					}
					return; # in perl etwas schneller als goto.(ca.10%)
				}
			}
			my $t = $l[$le]; $l[$le] = $l[$ri]; $l[$ri] = $t; #swap
			#print "SWAP ",$le+1," ", $ri+1,"\n";
		} 
		$le++;
	} while ( $le<$ri);

	label1:;
	if ( $l[$ri] & $b ){
		$ri--;
	}

	label:;

	$b = $b>>1;
	if ( $b ){
		if ( $s < $ri ){
			dobitsort($s,$ri,$b); 
		}
		if ( $ri+1 < $e ){
			dobitsort($ri+1,$e,$b); 
		}
	}
}


use Inline C => Config =>
	ENABLE => AUTOWRAP =>
	LIBS => '-llist';
use Inline C =>q{struct node* new_node(void* Object, struct node* Prev, struct node* Next, int Key );};

#use Inline C => <<'END_OF_C_CODE';
#include "list.h"






#END_OF_C_CODE
1;

