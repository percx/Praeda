# Tripp Lite Power Alert Device default password test
# 
######################################################
#                  PRAEDO Module #MA0017             #
#          Copyright (C) 2013 Foofus.net	     #
#              Deral Heiland    "percX"              # 
######################################################
package MA0017;
sub MA0017
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Default credential check on Tripp Lite Power Alert Device $TARGET : JOB MA0017**********\n";
print OUTFILE "\n**********Default credential check on Tripp Lite Power Alert Device $TARGET : JOB MA0017**********\n";

my $browser = LWP::UserAgent->new(timeout => 120);
$browser->default_header(Authorization=> "Basic YWRtaW46YWRtaW4=");

# Test  For Default Password

     my $InitialConnect = $browser->get("http$web://$TARGET:$PORTS/",);
     my $response = $browser->get("http$web://$TARGET:$PORTS/settings/network_snmp.htm",);

my $content = $response->content();
if ($content =~ /NMS Access Settings/)
        {
            print "SUCCESS : username=admin : password=admin\n";
            print OUTFILE "SUCCESS : username=admin : password=admin\n";

	    	my $html = HTML::TagParser->new($content);
                my @list = $html->getElementsByTagName( "input" );
    			foreach my $elem ( @list )
        			{
         			 my $text1 = $elem->getAttribute("name");
         			 my $text2 = $elem->getAttribute("value");
                 		    if (($text1 =~ /uN/) && ($text2 ne //))
                     			{
                       			   print "SNMP community String = $text2\n";
                       			   print OUTFILE "SNMP Read community String = $text2\n";
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
