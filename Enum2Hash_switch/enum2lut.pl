#!c:/perl64/bin/perl

####
#  
# (C) Marc Labelle 2013
# 

use strict;
use Data::Dumper;

#Usage, input a .h or .c/cpp file.  Scans through the file for any enums.  Produces empty switches based on the enums, one each with and without breaks.  output file name is switch.<sourcefile>

unless (open(IFH,$ARGV[0])){die(print "unable to open sourcefile: $!\n");}
unless (open(OFH,">lut.$ARGV[0]")){die(print "unable to open destfile: $!\n");}
my $inEnum=0;
my @enumAry=();
my @workingAry=();
while (my $line=<IFH>){
	if($line =~ /typedef enum/){$inEnum=1; @workingAry=undef;@workingAry=();next;}
	if($line =~ /\}/){my @temp=();$inEnum=0;push(@temp,@workingAry);push(@enumAry,\@temp);next;}
	if($inEnum){
		if($line=~/^\W*(\w+)\W*[=,]/ig){
			push (@workingAry,$1);
			print "$1\n";
		}
	}
}
close(IFH);

print Dumper \@enumAry;
print OFH "typedef struct _LUT {\n\tint command;\n\tchar * text;\n} LUT;\n";
foreach my $enum (@enumAry){
	print OFH "LUT lut[]={\n";
	foreach my $element (@{$enum}){
		print OFH "\t{$element,\"\"},\n";
	}
	print OFH "	{-1,\"undef\"}\n};\n";
}
close(OFH);