# Integrated Remote Access Controller 6 - Enterprise default password check  
# 
######################################################
#                  PRAEDO Module #MA0013             #
#          Copyright (C) 2012 Foofus.net	     #
#              Deral Heiland    "percX"              # 
######################################################
package MA0013;
sub MA0013
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on Integrated Remote Access Controller Device $TARGET : JOB MA0013**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on Integrated Remote Access Controller Device $TARGET : JOB MA0013**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);
my $response = new HTTP::Request GET =>"http://$TARGET:$PORTS/";

# enable redirect handeling for POST process
 push @{ $browser->requests_redirectable }, 'POST';

# Test  For Default Password
my $response = $browser->post("http$web://$TARGET/data/login",
[
"user" => "root",
"password" => "calvin",
]);

my $content = $response->content();

if ($content =~ /\<authResult\>0\<\/authResult\>/)
        {
            print "$TARGET : SUCCESS : username=root : password=calvin\n";
            print OUTFILE "$TARGET : SUCCESS : username=root : password=calvin\n";

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
