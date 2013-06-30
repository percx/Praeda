# Emerson Liebert Network Power IntelliSlot Card  default password test
# 
######################################################
#                  PRAEDO Module #MA0016             #
#          Copyright (C) 2013 Foofus.net	     #
#              Deral Heiland    "percX"              # 
######################################################
package MA0016;
sub MA0016
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Default credential check on Emerson IntelliSlot Card $TARGET : JOB MA0016**********\n";
print OUTFILE "\n**********Default credential check on Emerson IntelliSlot Card  $TARGET : JOB MA0016**********\n";

my $browser = LWP::UserAgent->new(timeout => 120);
$browser->default_header(Authorization=> "Basic TGllYmVydDpMaWViZXJ0");


# Test  For Default Password

     my $InitialConnect = $browser->get("http$web://$TARGET:$PORTS/config/configSnmpAccess.htm",);
     my $response = $browser->get("http$web://$TARGET:$PORTS/config/configSnmpAccess.htm",);

my $content = $response->content();
     
if ($content =~ /Device Configuration - SNMP Access/)
        {
            print "$TARGET : SUCCESS : username=Liebert : password=Liebert\n";
            print OUTFILE "$TARGET : SUCCESS : username=Liebert : password=Liebert\n";

	    	my $html = HTML::TagParser->new($content);
                my @list = $html->getElementsByTagName( "input" );
    			foreach my $elem ( @list )
        			{
         			 my $text1 = $elem->getAttribute("name");
         			 my $text2 = $elem->getAttribute("value");
                 		    if (($text1 =~ /accessCommunityString/) && ($text2 ne //))
                     			{
                       			   print "$TARGET : SUCCESS : SNMP community String = $text2\n";
                       			   print OUTFILE "$TARGET : SUCCESS : SNMP community String = $text2\n";
                     			}
                  	            else
                    			{
                   			}
				}

        }
        else 
        { 
           print "FAILED \n";
           print OUTFILE "FAILED \n";
        } 


# operation completed close out output files
close(OUTFILE);

}
		
1;
