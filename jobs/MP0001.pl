# HP COLOR LASERJET 4XXX Series Module for enumerating 
# user names from the Color Usage Job Logs.
######################################################
#                  PRAEDA Module #MP0001             #
#          Copyright (C) 2010 Foofus.net	     #
#               Deral "percX" Heiland                #
######################################################
package MP0001;
sub MP0001 
{
 
# Set global variables
my $count = 0;
my $num = 22;
my $loopy = 0;
my $strtrcd = 0;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my $jobs = 0;
my $browser = LWP::UserAgent->new(timeout => 30);


open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
print "Attempting to enumerate User Names from COLOR USAGE JOB LOG :MP0001\n";
print OUTFILE "Attempting to enumerate User Names from COLOR USAGE JOB LOG :MP0001\n";
open(TEMP, ">./$OUTPUT/temp_data.txt")|| die("Failed to open  Output file temp_data.txt \n");


# extract print job log count-----start-----

 my $html = HTML::TagParser->new( "http$web://$TARGET/hp/device/this.LCDispatcher?nav=hp.ColorUsage" );
    my @list = $html->getElementsByTagName( "span" );
    foreach my $elem ( @list )
    {
        my $text = $elem->innerText;
          if ($count eq 7)
               {
                print "Total possible record count $text\n";
                print OUTFILE "Total possible record count $text\n";
                $jobs = $text;
                $loopy = int($jobs/100)+1
               }
        $count = $count+1;
    }
# counter reset
$count = 0;

# extract print job log count------end-----


# HP Color Laserjet 4xxx user name recovery loop-----start-----
for(my $counter = 1; $counter <= $loopy; $counter++)
 {
# retrieve Color printer usage logs 
my $url1="http$web://$TARGET/hp/device/this.LCDispatcher?nav=hp.ColorUsage&startRecord=$strtrcd";
my $request = new HTTP::Request('GET', $url1);
my $response = $browser->request($request);
my $content = $response->content();
#**********************************************


# parse color printer usage logs
my $html = HTML::TagParser->new($content);

    my @records = $html->getElementsByTagName( "span" );
    foreach my $elem ( @records ) 
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
                       $num = $num+7;
		       print TEMP "$text\n"; 
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
 $num = 22;
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
#HP Color Laserjet 4xxx user name recovery loop-----end------


# operation completed close out output files
close(OUTFILE);
}
		
1;
