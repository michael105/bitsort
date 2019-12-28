#!/usr/bin/perl -w

my $c = 0;

sub qsort {
		@_ or return ();
		print join(" ",@_),"\n";
		my $p = shift;
		print "XXX\n";
		$c = $c + scalar(@_) *2 ;
		(qsort( grep( $_ < $p, @_)  ), $p, qsort(grep($_ >= $p, @_)));
}




print "\n",join(" ",qsort(@ARGV)),"\n";

print "$c Vergleiche\n";


