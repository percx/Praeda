#EtherPath Device SNMP 
######################################################
#                  PRAEDO Module #MA0012             #
#          Copyright (C) 2012 Foofus.net	     #
#              Deral Heiland    "percX"              # 
######################################################
package MA0012;
sub MA0012
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my $num = 2;


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to enumerate SNMP from EtherPath $TARGET : JOB MA0012**********\n";
print OUTFILE"\n**********Attempting to enumerate SNMP from EtherPath $TARGET : JOB MA0012**********\n";


# parse snmp setup data from page information on input tags TD
my $html = HTML::TagParser->new( "http$web://$TARGET:$PORTS/snmp.htm" );
 my @list = $html->getElementsByTagName( "input" );
    foreach my $elem ( @list )
        {
         my $text1 = $elem->getAttribute("name");
         my $text2 = $elem->getAttribute("value");
                 if ($text1 =~ /CMY/) 
                     {
                       print "$TARGET : SUCCESS : SNMP Read community String = $text2\n";
                       print OUTFILE "$TARGET : SUCCESS: SNMP Read community String = $text2\n";
                     }
                  else
                    {
                    }
        }



# operation completed close out output files
close(OUTFILE);

}
		
1;
