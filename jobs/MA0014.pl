# Pillar Axiom Performace Statistics Monitor -  SNMP settings
######################################################
#                  PRAEDO Module #MA0014             #
#          Copyright (C) 2012 Foofus.net	     #
#              Deral Heiland    "percX"              # 
######################################################
package MA0014;
sub MA0014
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my $num = 1;


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to enumerate SNMP settings from Pillar Axiom at $TARGET : JOB MA0001**********\n";
print OUTFILE "\n**********Attempting to enumerate Pillar Axiom SNMP settings for $TARGET are:\n";


# parse snmp setup data from page information on input tags TD
my $html = HTML::TagParser->new( "http$web://$TARGET:$PORTS/axiom_setup.php" );
    my @list = $html->getElementsByTagName( "input" );
    foreach my $elem ( @list )
  {
        my $text1 = $elem->getAttribute("name");
        my $text2 = $elem->getAttribute("value");
            
          if (( $text2 eq "" ) && ($num eq $count)) 
               {
               }
	  else 
               {
                  if ($num eq $count)
                     {
		       print OUTFILE "$text1 value = $text2\n";
                       $num = $num+1;
                     }
                  else 
                    {
                    }
             } 
	$count = $count+1;
    }

# operation completed close out output files
close(OUTFILE);

}
		
1;
