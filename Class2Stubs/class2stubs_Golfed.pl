#!c:/perl64/bin/perl

####
#  
# (C) Marc Labelle 2013
# 

unless ((open(OFH,">stub.$ARGV[0]"))&&(open(IFH,$ARGV[0]))){die(print "$!\n");}
my $iC=0;
my (%cH,$cn,@wA);
my $re=join('|',qw(UINT32 int UINT8 UINT16 short long double float char UCHAR));
while (<IFH>){
	if($_ =~ /class (\w+)/){$cn=$1;$iC=1; @wA=undef;@wA=();next;}
	elsif($_ =~ /\}/){my @temp=();$iC=0;push(@temp,@wA);$cH{$cn}=\@temp;next;}
	elsif($iC){if(($_=~/^\W*($re) (\w+)\(\);\W*\/\/\:(\w+)/ig)||($_=~/^\W*($re) (\w+)\(\);/ig)){push (@wA,[$1,$2,$3]);}}
}
foreach my $k (keys(%cH)){
	foreach (@{$cH{$k}}){	
		print OFH "$_->[0] $k" . "::$_->[1]()\n". gb(($_->[2] eq '')?'REPLACE_ME':$_->[2]) ."\n";
}	}
sub gb{	return <<END;
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
}
