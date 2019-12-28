#!/usr/bin/perl -w

BEGIN{ push @INC, ".", "/home/micha/prog/perl/modules";}
use strict;

# siehe für eine Beschreibung des Resultats auch benchmark_comparesort.pl

sub movesort_mist {
	#my @p = map { $$_ } @_;
	#printf(join("\n",@_));
	my $prev = 0;
	my @list;# = ( {p=>0,v=>1000000,n=>0} );
	push @list, {p=>0, v=>$_[0], n=>2};
	for my $e ( 1..scalar(@_)-1 ){
		push @list, {p=>$e, v=>$_[$e], n=>$e+1};
	}
	$list[@list-1]->{n}=0;
	
	#print "\n", join("  --  ",@list) ,"\n";
	#print Dumper(@list);

	for my $e ( 1 .. @list-1 ){
		my $pointer = $e-1;
		while ( exists($list[$pointer]->{p}) && ( $list[$e]->{v} > $list[$pointer]->{v} ) ){
			$pointer = $list[$pointer]->{p};
		}
		if ( $pointer != $e-1 ){
			$list[$list[$e]->{p}]->{n} = $e+1; # remove..
			$list[$list[$e]->{n}]->{p} = $e-1;

			$list[$e]->{n} = $list[$list[$pointer]->{p}]->{n};
			$list[$e]->{p} = $list[$list[$pointer]->{p}]->{p};

			$list[$list[$pointer]->{p}]->{n} = $e; # insert
			$list[$list[$pointer]->{n}]->{p} = $e
		}

	}
}



my $c = 0;
my $rec = 0;
my $heap = 0;
my $move = 0;

my @l;

sub resetcounter{
	$c=0;
	$rec=0;
	$heap = 0;
	$move = 0;
	@l=();
}

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
		$rec++;
		$heap = $heap + scalar(@_);
		@_ or return ();
		#print join(" ",@_),"\n";
		my $p = shift;
		#print "XXX\n";
		$c = $c + scalar(@_) *2 ;
		#(qsort( grep( $_ < $p, @_)  ), $p, qsort(grep($_ >= $p, @_)));
		# zum vergleichen ausbremsen..
		(qsort( qcomp1($p, @_) ), $p, qsort(qcomp2($p, @_)));
}



sub movesort{
	my @l = @_;

	for my $e ( 1..scalar(@l-1) ){
		my $p = $e;
		while ( $p && $l[$p] < $l[$p-1] ){
			my $t = $l[$p-1];
			$l[$p-1] = $l[$p];
			$l[$p] = $t;
			$p--;
			$c++;
		}
		$move++ if ( $p != $e );
		$c++;
	}
	return @l;
}

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

	dobitsort(0,$count,$bits);
	return(@l);
}

sub dobitsort{
	my($le,$ri,$b) = @_;
	if ( !$b || ($le>=$ri) ){ # $b wohl besser beim Aufruf abfragen, $le>=$ri wird im while loop abgefragt
#		print "Ret\n";
		return;
	}
	$rec++;
	$heap+=3;
#	print "\n",join("-",@l),"\n";
#	print $le+1," ", $ri+1,"    bits: $b\n";

	my $s = $le;
	my $e = $ri;
	my $p = $ri;
	my $bool = 0;
	while (  $le<$ri ){
		if ( $l[$le] & $b ){
			$c++;
			while ( $l[$ri] & $b ){
				$c++;
				$ri--;
				# hier evtl goto out of loop 
				if ( $le == $ri ){ # beide auf "und bit"
					#printf "X\n";
					dobitsort($s,$ri-1,$b>>1);
					dobitsort($ri,$e,$b>>1);
					return;
				}

			}
			$c++;
			my $t = $l[$le]; $l[$le] = $l[$ri]; $l[$ri] = $t; #swap
			$move++;
			#print "SWAP ",$le+1," ", $ri+1,"\n";
			$p = $ri-1;
			$bool = 1;
			#$ri--;
			#$ri immer AUF dem ersten
		} 
		$c++;
		$le++;
		if ( $le >= $ri ){ # $le nicht auf "und bit" (sonst oben..)
			if ( $l[$p] & $b ){
				$c++;
				$p--;
			}
			#if ( ($ri-2) != $p ){print "!!!!!!!!!!!!!!!!!!!, $ri, $p, $bool\n"; # immer bool = 0
			#} else {print "!!!!!!!!!!!!!!!!!!!! $bool\n";}  # immer bool = 1
			
			dobitsort($s,$p,$b>>1);
			dobitsort($p+1,$e,$b>>1);
			return;
		}

	}

	#print "HIER ???: $le $ri\n";

}


# FEHLERHAFT!!!
# @nl muss nicht zwingend übergeben werden, start- und anfangswert reichen.
sub dobitsort_mist{
	my $left = shift;
	my $right = shift;
	my $bits = shift;
	my $oldr = $right;
	return if ( $left >=$right );
	$rec++;
	$heap += 3;
	print join("-",@l),"\n\n";
	print "left ",$left+1,"   right ",$right+1,"   bits $bits\n";
	my $start = $left;
	my $end = $right;
	my $lmoved = 0;
	my $rmoved = 0;
	while ( ($l[$right] & $bits) && ($left < $right) ){
		$c++;
		$right--;
	}
	while ( (!($l[$right] & $bits)) && ($left < $right) ){
		$c++;
		while ( (!($l[$left] & $bits )) && ($left<$right) ){
			$c++;
			$left++;
		}
		if ( $left < $right ){
			my $t = $l[$right];
			$l[$right] = $l[$left];
			$l[$left] = $t;
			$left++;
			$move++;
			#$rmoved = 1;
		}
		$right--;
	}

	print join("-",@l),"\n\n";

	while ( $left < $right ){
		if ( $l[$left] & $bits ){
			printf "Ja: $left   $l[$left] & $bits\n";
			$c++;
			print "Swap ",$left+1," ",$right+1,"\n";
			if ( $left < $right ){
				my $t = $l[$right];
				$l[$right] = $l[$left];
				$l[$left] = $t;
				$right--;
				$move++;
				#$rmoved = 1;
			}
		} else {
			$c++;
		}
		$left++;
	}
	$bits = $bits >> 1;
	#print "$start $right $end $bits\n";
	# FEHLER!!!... / right -1 ist nicht korrekt, falls right nicht heruntergezählt wurde.
	$right++ if ( !$rmoved );
	$left++ if ( !$lmoved );
	if ( $bits > 0 ){
		dobitsort($start,$right-1,$bits);
		dobitsort($right,$end, $bits);
#		dobitsort($right+1,$end,$bits);
	}

}


print "\n",join(" ",qsort(@ARGV)),"\n";

print "$c Vergleiche, $rec Rekursionen: Heapusage: $heap\n";
resetcounter();
print "\n",join(" ",movesort(@ARGV)),"\n";
print "$c Vergleiche, move: $move\n\n";

resetcounter();
$move = 0;
print "\n",join(" ",bitsort(@ARGV)),"\n";
print "$c Vergleiche, $move move, $rec Rekursionen, Heap: ",$heap,"\n";
if ( !prove(bitsort(@ARGV))){
	print "Not proved.??\n";
}

#exit(0);

resetcounter();
use Misc::Tables;
my @titles = qw/N MaxValue/;
foreach my $a (qw/Cmp Move Rec Heap/){
	foreach my $b (qw/qsort msort bsort/){
		push @titles, "$a $b";
	}
}

my $table = Misc::Tables->new( titles=>[qw/N Max Inst qsort movesort bitsort/], bordertype=>'none' );


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

use Benchmark qw(:all);
for my $n( 2..10,20,30,50,100,200,500,1000 ){
	for my $max( 4,16,50,100,200,1000,10000 ){
	my @ac;
	my @amove;
	my @arec;
	my @aheap;
	my @list;
	for ( 0..$n ){
		push @list, int(rand($max));
	}
	@l = @list;
#	print "Count: $n    Max: $max\n";
#	timethese( 10, {qsort=>sub{qsort(@list)}, movesort=>sub{movesort(@list)}, bitsort=>sub{bitsort(@list)}} );

#}} exit 0;
#__DATA__

	#print "qsort\n";
	prove("qsort", \@list, qsort(@list));
	push @ac,$c;
	push @amove,$move;
	push @arec,$rec;
	push @aheap,$heap;
	resetcounter();
	#print "movesort\n";
	prove("movesort",\@list, movesort(@list) );
	push @ac,$c;
	push @amove,$move;
	push @arec,$rec;
	push @aheap,$heap;

	resetcounter();
	#print "bitsort\n";
	prove( "bitsort", \@list, bitsort(@list));
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


$table->show();



__DATA__

(Benchmarks)
wohl eher nicht representativ,
insbesondere die hohe Zahl von Vergleichen bei qsort im Vergleich zu bitsort spricht irgendwie Bände.
verm. ist grep sehr schnell.

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



