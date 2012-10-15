# Digi Configuration and Management default password test
# 
######################################################
#                  PRAEDO Module #MA0011             #
#          Copyright (C) 2012 Foofus.net	     #
#              Deral Heiland    "percX"              # 
######################################################
package MA0011;
sub MA0011
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on Digi Configuration and Management Device $TARGET : JOB MA0011**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on Digi Configuration and Management Device $TARGET : JOB MA0011**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);
my $response = new HTTP::Request GET =>"http://$TARGET:$PORTS/";

# enable redirect handeling for POST process
 push @{ $browser->requests_redirectable }, 'POST';

# Test  For Default Password
my $response = $browser->post("http$web://$TARGET/Forms/login_1",
[
"cache" => "",
"protocol" => "http",
"username" => "root",
"password" => "dbps",
"btLogin" => "Login",
]);
     
# userid=root&password=dbps&login=Login

my $content = $response->content();

if ($content =~ /Configuration and Management/)
        {
            print "Default Credentials : username=root : password=dbps\n";
            print OUTFILE "Default Credentials : username=root : password=dbps\n";
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
