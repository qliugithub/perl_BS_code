#!/usr/bin/perl -w

#use File::Spec;
#my $outFile_ge9 = File::Spec->catfile($outDir, join(".", @parts) . "_ge9." . $ext);

use strict;
use File::Spec;

my $debug = 0;

if($debug){
	print STDERR "debug = 1\n\n";
}
#my $usage = "$0 <input> <output>";
#die $usage unless(@ARGV == 2);

my $usage = "$0]\n <input> STDOUT \n\n";
die $usage unless(@ARGV == 1);


my $input = shift or die;
#my $output = shift or die;

die unless (-e $input);
#die if( -e $output);

open(IN, $input) or die "cannot open $input: $!";

#die if(-e $output);
#open(OUT, ">$output") or die "cannot open $output: $!";

my $head = <IN>;
chomp $head;
#print  join("\t", ($head, "high_weigth_meth_level", "low_weigth_meth_level")), "\n";
print  join("\t", ($head, "high_C_per", "low_C_per")), "\n";

#0			1	2	 3		  4			5		6		7				8		9	  	10		11			12		13				14		15
#chr	start	end	DMC_num	 wt_CG	wt_CG_per	wt_CHG	wt_CHG_per	wt_CHH	wt_CHH_per	mut_CG	mut_CG_per	mut_CHG	mut_CHG_per	 mut_CHH	mut_CHH_per


#0			1		2	 3		  4			5		6		7		8		9	  10		11		12		13		14		15
#chr1    42319   42670   20      5/9=    55.5556 2/35=   5.7143  68/451= 15.0776 0/8=    0.0000  0/39=   0.0000  4/324=  1.2346
while(<IN>){
	chomp;
	my @a = split "\t";
#	my ($cg, $chg, $chh) = @[26..28];
	my @b = @a[26..28];
#	my $high_sum = 0;
#	my $low_sum  = 0;
	my ($high_mC , $high_dep) = (0, 0);
	my ($low_mC , $low_dep) = (0, 0);
	for my $i(0..2){
	#	next if ($b[$i] == 0);
	#	$high_sum += $b[$i] * $a[2*$i + 5];
	#	$low_sum  += $b[$i] * $a[2*$i + 11];
		my ($high_mC_sub , $high_dep_sub ) = get_two_val($a[2*$i + 4]);
		$high_mC  += $high_mC_sub;
		$high_dep += $high_dep_sub;
		
		my ($low_mC_sub , $low_dep_sub ) = get_two_val($a[2*$i + 10]);
		$low_mC  += $low_mC_sub;
		$low_dep += $low_dep_sub;
	}
	
	my $num = $b[0] + $b[1] + $b[2] ;
	print  join("\t", (@a, sprintf("%.4f",100* $high_mC / $high_dep), sprintf("%.4f",100* $low_mC / $low_dep) )), "\n";
	
}

close(IN);
#close(OUT);

exit;

sub get_two_val{
	my ($x) = @_;
	$x =~ s/=//;
	my ($a, $b) = split "/", $x;
	return ($a, $b);
}