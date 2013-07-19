# Pelco Sarix Camera -  default password check  
# 
######################################################
#                  PRAEDO Module #MA0019             #
#          Copyright (C) 2013 Foofus.net	     #
#              Deral Heiland    "percX"              # 
######################################################
package MA0019;
sub MA0019
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on Pelco Sarix Camera Device $TARGET : JOB MA0019**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on Pelco Sarix Camera Device $TARGET : JOB MA0019**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);
my $response = new HTTP::Request GET =>"http://$TARGET:$PORTS/";


# Setup cookie and place in cookie jar
 $cookie_jar = HTTP::Cookies->new();
 my $browser = LWP::UserAgent->new(timeout => 120);
 $browser->cookie_jar($cookie_jar);

# enable redirect handeling for POST process
 push @{ $browser->requests_redirectable }, 'POST';

# Test  For Default Password
my $response = $browser->post("http$web://$TARGET/auth/validate",
[
"username" => "admin",
"password" => "admin",
]);
my $content = $response->content();

if ($content =~ /Logout admin/)
        {
            print "$TARGET : SUCCESS : username=admin : password=admin\n";
            print OUTFILE "$TARGET : SUCCESS : username=admin : password=admin\n";

# check SNMP community string settings
            $response = $browser->get("http$web://$TARGET/setup/network/snmp",);
            $content = $response->content();
			 my $html = HTML::TagParser->new($content);
                	 my @list = $html->getElementsByTagName( "input" );
                       	 foreach my $elem ( @list )
                                {
                                 my $text1 = $elem->getAttribute("name");
                                 my $text2 = $elem->getAttribute("value");
                                    if (($text1 =~ /community_string/) && ($text2 ne //))
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
