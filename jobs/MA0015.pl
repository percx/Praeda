# CoyotePoint Equalizer -  default password check  
# 
######################################################
#                  PRAEDO Module #MA0015             #
#          Copyright (C) 2012 Foofus.net	     #
#              Deral Heiland    "percX"              # 
######################################################
package MA0015;
sub MA0015
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on CoyotePoint Equalizer Device $TARGET : JOB MA0015**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on CoyotePoint EqualizerDevice $TARGET : JOB MA0015**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);
my $response = new HTTP::Request GET =>"http://$TARGET:$PORTS/";

# enable redirect handeling for POST process
 push @{ $browser->requests_redirectable }, 'POST';

# Test  For Default Password
my $response = $browser->post("http$web://$TARGET/",
[
"form" => "login",
"USER" => "touch",
"PASS" => "touch",
"login" => "login",
]);
my $content = $response->content();

if ($content =~ /Administration Interface/)
        {
            print "SUCCESS : username=touch : password=touch\n";
            print OUTFILE "SUCCESS : username=touch : password=touch\n";

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
