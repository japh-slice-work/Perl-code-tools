#!c:/perl64/bin/perl

####
#  
# (C) Marc Labelle 2013
# 

use strict;
use Data::Dumper;

#Usage, input a .h or .c/cpp file.  Scans through the file for any class definitions and produces code stubs for function declrations.  A fill value can be specified in the source file by putting a \\: followed by the value to fill.


unless (open(IFH,$ARGV[0])){die(print "unable to open sourcefile: $!\n");}
unless (open(OFH,">stub.$ARGV[0]")){die(print "unable to open destfile: $!\n");}

my @supportedTypeDefs= qw(UINT32 int UINT8 UINT16 short long double float char UCHAR);
my $inClass=0;
my %classHash;
my @workingAry=();
my $classname;
my $fillValue;
my $defs=join('|',@supportedTypeDefs);
while (my $line=<IFH>){
	if($line =~ /class (\w+)/){$classname=$1;$inClass=1; @workingAry=undef;@workingAry=();print"classname:$classname\n";next;}
	if($line =~ /\}/){my @temp=();$inClass=0;push(@temp,@workingAry);$classHash{$classname}=\@temp;next;}
	if($inClass){
		if(($line=~/^\W*($defs) (\w+)\(\);\W*\/\/\:(\w+)/ig)||($line=~/^\W*($defs) (\w+)\(\);/ig)){
			push (@workingAry,[$1,$2,$3]);
			print ">$1<:>$2<\n";
		}
	}
}
close(IFH);
print"classname:$classname\n";

print Dumper \%classHash;
foreach my $key (keys(%classHash)){
	foreach my $element (@{$classHash{$key}}){
		print ${$element}[2];
		unless(${$element}[2] eq ''){$fillValue=${$element}[2];}
		else{$fillValue='REPLACE_ME';}
		print $fillValue;
		print OFH "$$element[0] $key" . "::$$element[1]()\n". GenBody($fillValue) ."\n";
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
      //   this->SendVpCommand($_[0] , outBuffer, bufferSize);
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
	return(returnValue);
};
END
	return $body;
}
