#!/usr/bin/perl -w

#use File::Spec;
#my $outFile_ge9 = File::Spec->catfile($outDir, join(".", @parts) . "_ge9." . $ext);

use strict;
use File::Spec;

my $debug = 0;

if($debug){
	print STDERR "debug = 1\n\n";
}

my $TE_DB_list = "/Users/tang58/DataBase/TAIR10/TE/TAIR10_TE_closest_protein_coding_gene_nodupl.txt";
die unless (-e $TE_DB_list);

my $usage = "$0 <input> <min_cutoff> <max_length_cutoff> STDOUT";
die $usage unless(@ARGV == 3);

my $TE_name_list = shift or die;
die unless (-e $TE_name_list);

my $min_length_cutoff = shift or die;
my $max_length_cutoff = shift or die;

my %records;

read_TE_name($TE_name_list, \%records);

output($TE_DB_list,  \%records , $min_length_cutoff, $max_length_cutoff );


exit;

sub output{
	my ($file, $ref, $min, $max) = @_;
	die unless (-e $file);
	
	open(IN, $file)  or die;
	
	my $head = <IN>;
	print $head;
	while(<IN>){
		chomp;
		my @a = split "\t";
		print $_, "\n" if (defined $ref->{$a[4]} and $a[3] >= $min and $a[3] <= $max);
	}
	close(IN);

}

sub read_TE_name{
	my ($file, $ref) = @_;
	die unless (-e $file);
	
	open(IN, $file)  or die;
	while(<IN>){
		chomp;
		$ref->{$_} = 1;
	}
	close(IN);
}
