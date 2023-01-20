#!c:/perl64/bin/perl

####
#  
# (C) Marc Labelle 2013
# 

use strict;
use Data::Dumper;

#Usage, input a .h or .c/cpp file.  Scans through the file for any enums.  Produces empty switches based on the enums, one each with and without breaks.  output file name is switch.<sourcefile>

unless (open(IFH,$ARGV[0])){die(print "unable to open sourcefile: $!\n");}
unless (open(OFH,">stub.$ARGV[0]")){die(print "unable to open destfile: $!\n");}

my $inClass=0;
my @classAry=();
my @workingAry=();
my $classname;
while (my $line=<IFH>){
	if($line =~ /class (\w+)/){$classname=$1;$inClass=1; @workingAry=undef;@workingAry=();print"classname:$classname\n";next;}
	if($line =~ /\}/){my @temp=();$inClass=0;push(@temp,@workingAry);push(@classAry,\@temp);next;}
	if($inClass){
		if($line=~/^\W*UINT32 (\w+)\(\);/ig){
			push (@workingAry,$1);
			print "$1\n";
		}
	}
}
close(IFH);
print"classname:$classname\n";
my $body= <<END;
{
   UINT32 returnValue = 0;
   char outBuffer[256] = {0};
   int bufferSize = sizeof(outBuffer);

   switch(this->mode) {
      case MODE_USING_VP:
         this->SendVpCommand(CMD_ENUM , outBuffer, bufferSize);
         break;
      case MODE_USING_FPGA_SA:
      case MODE_USING_FPGA_VEGA:
         break;
      case MODE_USING_HYBRID:
         break;
      case MODE_USING_REAL_SI:
      default:
         break;
   }

};
END

#print Dumper \@classAry;
foreach my $enum (@classAry){
	foreach my $element (@{$enum}){
		print OFH "UINT32 $classname" . "::$element()\n$body\n";
	}
}
close(OFH);