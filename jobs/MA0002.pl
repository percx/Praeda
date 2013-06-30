# EMC Celerra NAS device default password test
# 
######################################################
#                  PRAEDO Module #MA0002             #
#          Copyright (C) 2010 Foofus.net	     #
#    __        ___      __   __                __    #
# | /  \ \    /  _/___ |__| _\ |___  _ __   | /  \ | #
#\_\\  //_/   \_  \ . \|  |/ . / ._\| `_/  \_\\  //_/#
# .'/()\'.    /___/  _/|__|\___\___\|_|     .'/()\'. #
#  \\  //         |_\                       \ \  / / #
######################################################
package MA0002;
sub MA0002
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on EMC Celerra NAS device $TARGET : JOB MA0002**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on EMC Celerra NAS device $TARGET : JOB MA0002**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);

# Test For Default Passwords

     my $response = $browser->get("http$web://$TARGET:$PORTS/Login?banner=hello%20world&user=root&password=nasadmin&Login=Login&request_uri=/",);

my $content = $response->content();
     
if ($content =~ /You have successfully authenticated/) {
            print "$TARGET : SUCCESS : username=root : password=nasadmin\n"; 
            print OUTFILE "$TARGET : SUCCESS : username=root : password=nasadmin\n"; 
        }
        else { 
            print " FAILED \n";
	    print OUTFILE "FAILED \n";
        } 


# operation completed close out output files
close(OUTFILE);

}
		
1;
