#!c:/perl64/bin/perl

####
#  
# (C) Marc Labelle 2013
# 

use strict;
use Data::Dumper;

#Usage, input a .h or .c/cpp file.  Scans through the file for any class definitions and produces code stubs for function declrations.  currently only supports UINT32.  A fill value can be specified in the source file by putting a \\: followed by the value to fill.


unless (open(IFH,$ARGV[0])){die(print "unable to open sourcefile: $!\n");}
unless (open(OFH,">stub.$ARGV[0]")){die(print "unable to open destfile: $!\n");}

my $inClass=0;
my %classHash;
my @workingAry=();
my $classname;
my $fillValue;
while (my $line=<IFH>){
	if($line =~ /class (\w+)/){$classname=$1;$inClass=1; @workingAry=undef;@workingAry=();print"classname:$classname\n";next;}
	if($line =~ /\}/){my @temp=();$inClass=0;push(@temp,@workingAry);$classHash{$classname}=\@temp;next;}
	if($inClass){
		if(($line=~/^\W*UINT32 (\w+)\(\);\W*\/\/\:(\w+)/ig)||($line=~/^\W*UINT32 (\w+)\(\);/ig)){
			push (@workingAry,[$1,$2]);
			print ">$1<:>$2<\n";
		}
	}
}
close(IFH);
print"classname:$classname\n";

print Dumper \%classHash;
foreach my $key (keys(%classHash)){
	foreach my $element (@{$classHash{$key}}){
		print ${$element}[1];
		unless(${$element}[1] eq ''){$fillValue=${$element}[1];}
		else{$fillValue='REPLACE_ME';}
		print $fillValue;
		print OFH "UINT32 $key" . "::$$element[0]()\n". GenBody($fillValue) ."\n";
	}
}
close(OFH);


sub GenBody{
my $body= <<END;
{
   UINT32 returnValue = 0;
   char outBuffer[256] = {0};
   int bufferSize = sizeof(outBuffer);

   switch(this->mode) {
      case MODE_USING_VP:
         this->SendVpCommand($_[0] , outBuffer, bufferSize);
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
	return $body;
}
