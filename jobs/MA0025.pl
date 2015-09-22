# DELL Metered Rack PDU default password test and SNMP community string extract
# 
######################################################
#               PRAEDA Module #MA0025                #
#                 Copyright (C) 2015                 #
#              Deral Heiland    "Percent_x"          # 
######################################################
package MA0025;
sub MA0025
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Default credential check on Dell Metered Rack PDU $TARGET : JOB MA0025**********\n";
print OUTFILE "\n**********Default credential check on Dell Mtered Rack PDU $TARGET : JOB MA0025**********\n";

my $browser = LWP::UserAgent->new(timeout => 120);
$browser->default_header(Authorization=> "Basic YWRtaW46YWRtaW4=");

# Test  For Default Password

     my $InitialConnect = $browser->get("http$web://$TARGET:$PORTS/",);
     my $response = $browser->get("http$web://$TARGET:$PORTS/PageTrap.htm",);

my $content = $response->content();
if ($content =~ /TRAP Receivers Page/)
        {
            print "$TARGET : SUCCESS : username=admin : password=admin\n";
            print OUTFILE "$TARGET : SUCCESS : username=admin : password=admin\n";

	    	my $html = HTML::TagParser->new($content);
                my @list = $html->getElementsByTagName( "input" );
    			foreach my $elem ( @list )
        			{
         			 my $text1 = $elem->getAttribute("name");
         			 my $text2 = $elem->getAttribute("value");
                 		    if (($text1 =~ /XAAAAAAABKACB/) && ($text2 ne //))
                     			{
                       			   print "$TARGET : SUCCESS : SNMP Read Community = $text2\n";
                       			   print OUTFILE "$TARGET : SUCCESS : SNMP Read community  = $text2\n";
                     			}
                                     elsif (($text1 =~ /XAAAAAAABKACJ/) && ($text2 ne //))
                                        {
                                           print "$TARGET : SUCCESS : SNMP Write Community = $text2\n";
                                           print OUTFILE "$TARGET : SUCCESS : SNMP Write community = $text2\n";
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
