#!/usr/bin/perl -w

#use strict;
my @l;


BEGIN{ push @INC, ".", "/home/micha/prog/perl/modules";}

use Benchmark qw(:all);

# Insegesamt betrachtet:
#
# qsort hat verdammt viele nicht vermeidbare verschiebe(kopier-) operationen,
# desweiteren kommen regeläßig bei bestimmten Werten Heap-Überläufe vor.
#
# movesort kann hier nicht angemessen verglichen werden,
# da für jedes Bewegen eines Listenelements x swap operationen ausgeführt werden müssen.
# mit Sicherheit ist movesort nicht die schlechteste Wahl,
# insbesondere aufgrund des konstanten Speicherverbrauchs (0)
# sowie bei schon halbwegs vorsortierten Eingabedaten
#
# bitsort schneidet hier insgesamt am Besten ab (insbesondere ist zu beachten,
# dass die test instruktion nur 1 Clockcycle benötigt.
# Parallelisierung ebenfalls einfach machbar.)
#
# Für bitsort ist allerdings eine Swap Funktion äußerst sinnvoll.
# (d.h. Listenelemente einer verlinkten Liste sollten am Besten nur auf die Daten zeigen,
# somit muss nur der Zeiger vertauscht werden, nicht die Zeiger auf, und von dem nächsten und früheren Element.
#
# aufgrund der fixen maximalen Rekursionstiefe liesse sich bitsort
# auch "ausrollen". -> grob geschätzt für 8 bit 1kb MaschinenCode.


my $c = 0;
my $rec = 0;
my $heap = 0;
my $move = 0;


sub resetcounter{
	$c=0;
	$rec=0;
	$heap = 0;
	$move = 0;
	@l=();
}


use bitsort;

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

use Misc::Tables;

my $table = Misc::Tables->new( titles=>[qw/N Max Inst qsort movesort bitsort/], bordertype=>'none' );

#for ( 1..20){
#for my $n( 10,20,30,50,100,200,500,1000 ){
for my $n( 500,1000,5000 ){
	for my $max( 16,50,100,200,1000,10000 ){ # bei 4 heapüberlauf bei qsort.
	my @list;
	for ( 0..$n ){
		push @list, int(rand($max));
	}
	@l = @list;
	print "Count: $n    Max: $max\n";
	prove( "bitsort", \@list, bitsort::bitsort(@list));
	bitsort::cmp_bitsort(@list);
	#timethese( 10, {qsort=>sub{qsort(@list)}, movesort=>sub{movesort(@list)}, bitsort=>sub{bitsort::bitsort(@list)}} );
	#timethese( 50, {qsort=>sub{qsort(@list)},  bitsort=>sub{bitsort(@list)}} );
}}; 
exit 0;
__DATA__

	#print "qsort\n";
	my @ac;
	my @amove;
	my @arec;
	my @aheap;

	resetcounter();
	#print "bitsort\n";
	prove( "bitsort", \@list, bitsort::bitsort(@list));
	push @ac,$c;
	push @amove,$move;
	push @arec,$rec;
	push @aheap,$heap;

	resetcounter();
	print "$n $max :",join("   ",@ac),"\n";
	print "$n $max :",join("      ",@amove),"\n";
	print "$n $max :",join("      ",@arec),"\n";
	print "$n $max :",join("     ",@aheap),"\n";
	print "\n\n";
	$table->add_row( $n,$max,"cmp",@ac );
	$table->add_row( $n,$max,"mov",@amove );
	$table->add_row( $n,$max,"rec",@arec );
	$table->add_row( $n,$max,"heap",@aheap );
	}

}
}

#$table->show();



__DATA__

(Benchmarks)
wohl eher nicht representativ,
insbesondere die hohe Zahl von Vergleichen bei qsort im Vergleich zu bitsort spricht irgendwie Bände.
verm. ist grep sehr schnell.

Welten besser..
Count: 1000    Max: 16
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.03 usr +  0.00 sys =  0.03 CPU) @ 333.33/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.69 usr +  0.00 sys =  3.69 CPU) @  2.71/s (n=10)
qsort:  0 wallclock secs ( 0.42 usr +  0.00 sys =  0.42 CPU) @ 23.81/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 50
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.04 usr +  0.00 sys =  0.04 CPU) @ 250.00/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.85 usr +  0.00 sys =  3.85 CPU) @  2.60/s (n=10)
qsort:  0 wallclock secs ( 0.23 usr +  0.00 sys =  0.23 CPU) @ 43.48/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 100
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.05 usr +  0.00 sys =  0.05 CPU) @ 200.00/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.75 usr +  0.01 sys =  3.76 CPU) @  2.66/s (n=10)
qsort:  0 wallclock secs ( 0.21 usr +  0.00 sys =  0.21 CPU) @ 47.62/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 200
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.05 usr +  0.00 sys =  0.05 CPU) @ 200.00/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.94 usr +  0.00 sys =  3.94 CPU) @  2.54/s (n=10)
qsort:  0 wallclock secs ( 0.19 usr +  0.00 sys =  0.19 CPU) @ 52.63/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 1000
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.09 usr +  0.00 sys =  0.09 CPU) @ 111.11/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  3 wallclock secs ( 3.79 usr +  0.00 sys =  3.79 CPU) @  2.64/s (n=10)
qsort:  1 wallclock secs ( 0.17 usr +  0.00 sys =  0.17 CPU) @ 58.82/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 10000
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.12 usr +  0.00 sys =  0.12 CPU) @ 83.33/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.87 usr +  0.00 sys =  3.87 CPU) @  2.58/s (n=10)
qsort:  0 wallclock secs ( 0.16 usr +  0.00 sys =  0.16 CPU) @ 62.50/s (n=10)
(warning: too few iterations for a reliable count)



Count: 1000    Max: 16
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.05 usr +  0.00 sys =  0.05 CPU) @ 200.00/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.65 usr +  0.00 sys =  3.65 CPU) @  2.74/s (n=10)
qsort:  0 wallclock secs ( 0.15 usr +  0.00 sys =  0.15 CPU) @ 66.67/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 50
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.07 usr +  0.00 sys =  0.07 CPU) @ 142.86/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.77 usr +  0.00 sys =  3.77 CPU) @  2.65/s (n=10)
qsort:  0 wallclock secs ( 0.08 usr +  0.00 sys =  0.08 CPU) @ 125.00/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 100
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.08 usr +  0.00 sys =  0.08 CPU) @ 125.00/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.83 usr +  0.00 sys =  3.83 CPU) @  2.61/s (n=10)
qsort:  0 wallclock secs ( 0.07 usr +  0.00 sys =  0.07 CPU) @ 142.86/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 200
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.09 usr +  0.00 sys =  0.09 CPU) @ 111.11/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.64 usr +  0.00 sys =  3.64 CPU) @  2.75/s (n=10)
qsort:  0 wallclock secs ( 0.06 usr +  0.00 sys =  0.06 CPU) @ 166.67/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 1000
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.13 usr +  0.00 sys =  0.13 CPU) @ 76.92/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.77 usr +  0.00 sys =  3.77 CPU) @  2.65/s (n=10)
qsort:  0 wallclock secs ( 0.06 usr +  0.00 sys =  0.06 CPU) @ 166.67/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 10000
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.17 usr +  0.00 sys =  0.17 CPU) @ 58.82/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.95 usr +  0.01 sys =  3.96 CPU) @  2.53/s (n=10)
qsort:  0 wallclock secs ( 0.06 usr +  0.00 sys =  0.06 CPU) @ 166.67/s (n=10)
(warning: too few iterations for a reliable count)


"aussagekräftiger" (grep aus qsort rausgeschmissen.)
Count: 1000    Max: 16
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.05 usr +  0.00 sys =  0.05 CPU) @ 200.00/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.68 usr +  0.01 sys =  3.69 CPU) @  2.71/s (n=10)
qsort:  0 wallclock secs ( 0.40 usr +  0.00 sys =  0.40 CPU) @ 25.00/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 50
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.07 usr +  0.00 sys =  0.07 CPU) @ 142.86/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.65 usr +  0.00 sys =  3.65 CPU) @  2.74/s (n=10)
qsort:  0 wallclock secs ( 0.23 usr +  0.00 sys =  0.23 CPU) @ 43.48/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 100
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.08 usr +  0.00 sys =  0.08 CPU) @ 125.00/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.76 usr +  0.00 sys =  3.76 CPU) @  2.66/s (n=10)
qsort:  0 wallclock secs ( 0.18 usr +  0.00 sys =  0.18 CPU) @ 55.56/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 200
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.09 usr +  0.00 sys =  0.09 CPU) @ 111.11/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.81 usr +  0.00 sys =  3.81 CPU) @  2.62/s (n=10)
qsort:  0 wallclock secs ( 0.17 usr +  0.00 sys =  0.17 CPU) @ 58.82/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 1000
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  0 wallclock secs ( 0.13 usr +  0.00 sys =  0.13 CPU) @ 76.92/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  4 wallclock secs ( 3.76 usr +  0.00 sys =  3.76 CPU) @  2.66/s (n=10)
qsort:  0 wallclock secs ( 0.16 usr +  0.00 sys =  0.16 CPU) @ 62.50/s (n=10)
(warning: too few iterations for a reliable count)
Count: 1000    Max: 10000
Benchmark: timing 10 iterations of bitsort, movesort, qsort...
bitsort:  1 wallclock secs ( 0.17 usr +  0.00 sys =  0.17 CPU) @ 58.82/s (n=10)
(warning: too few iterations for a reliable count)
movesort:  3 wallclock secs ( 3.76 usr +  0.00 sys =  3.76 CPU) @  2.66/s (n=10)
qsort:  1 wallclock secs ( 0.16 usr +  0.00 sys =  0.16 CPU) @ 62.50/s (n=10)
(warning: too few iterations for a reliable count)



