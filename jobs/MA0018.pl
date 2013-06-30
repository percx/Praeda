#Binatone ADSL Wireless Modem Router DT 845W
#
######################################################
#                  PRAEDA Module #MA0018             #
#          Copyright (C) 2013 Foofus.net             #
#              Deral Heiland    "percX"              #
######################################################
package MA0018;
sub MA0018
{


# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];

# Open output file and setup browser LWP function
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Default credential check on ADSL Wireless Modem Device $TARGET : JOB MA0018**********\n";
print OUTFILE "\n**********Default credential check on Binatone ADSL Wireless Modem Router DT 845W Device $TARGET : JOB MA0018**********\n";

my $browser = LWP::UserAgent->new(timeout => 120);
$browser->default_header(Authorization=> "Basic YWRtaW46cGFzc3dvcmQ=");

# Test  For first default password of "password
     my $InitialConnect = $browser->get("http$web://$TARGET/",);
     my $response = $browser->get("http$web://$TARGET/",);

my $content = $response->content();
if ($content =~ /navigation-status.html/)
        {
            print "$TARGET : SUCCESS : username=admin : password=password\n";
            print OUTFILE "$TARGET : SUCCESS : username=admin : password=password\n";
        }
        else
        {
# Test for second default password of "admin"
	   $browser->default_header(Authorization=> "Basic YWRtaW46YWRtaW4=");
     	   $InitialConnect = $browser->get("http$web://$TARGET/",);
     	   $response = $browser->get("http$web://$TARGET/",);

	   $content = $response->content();
		if ($content =~ /navigation-status.html/)
        	{
            	    	print "$TARGET : SUCCESS : username=admin : password=admin\n";
            		print OUTFILE "$TARGET : SUCCESS : username=admin : password=admin\n";
        	}
        	else
        	{
           	    	print "FAILED \n";
           	    	print OUTFILE "FAILED \n";
        	}
        }

# operation completed close out output files
close(OUTFILE);
}

1;
