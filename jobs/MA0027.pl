# APC -  default password check  
# 
######################################################
#                  PRAEDO Module #MA0027             #
#                    Copyright (C) 2015 	     #
#               Deral Heiland "Percent_X"            #
######################################################
package MA0027;
sub MA0027
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on APC Device $TARGET : JOB MA0027**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on APC Device $TARGET : JOB MA0027**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);
my $response = new HTTP::Request GET =>"http://$TARGET:$PORTS/";

# enable redirect handeling for POST process
 push @{ $browser->requests_redirectable }, 'POST';

# Test  For Default Password
my $response = $browser->post("http$web://$TARGET/Forms/login1",
[
"login_username" => "apc",
"login_password" => "apc",
"submit" => "Login+On",
]);
my $content = $response->content();

if ($content =~ /home.htm/)
        {
            print "$TARGET : SUCCESS : username=apc : password=apc\n";
            print OUTFILE "$TARGET : SUCCESS : username=apc : password=apc\n";

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
