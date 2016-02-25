#Check default creds on EMC Connectrix 
# 
######################################################
#               PRAEDA Module #MA0030                #
#                 Copyright (C) 2015                 #
#              Deral Heiland    "Percent_x"          # 
######################################################
package MA0030;
sub MA0030
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Default credential check on EMC Connectrix $TARGET : JOB MA0030**********\n";
print OUTFILE "\n**********Default credential check on EMC Connectrix $TARGET : JOB MA0030**********\n";

my $browser = LWP::UserAgent->new(timeout => 120);
$browser->default_header(Authorization=> "Basic YWRtaW46cGFzc3dvcmQ6NTMwNzU4MTQ1");

# Test  For Default Password

     my $InitialConnect = $browser->get("http$web://$TARGET:$PORTS/",);
     my $response = $browser->get("http$web://$TARGET:$PORTS/SnmpConfig.html",);

my $content = $response->content();
if ($content =~ /communityString/)
        {
            print "$TARGET : SUCCESS : username=admin : password=password\n";
            print OUTFILE "$TARGET : SUCCESS : username=admin : password=password\n";
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
