# Xerox Phaser7750 Job Account Record Download
######################################################
#                    PRAEDA Module #MP0006           #
#        Copyright (C) 2010 Foofus.net		     #
#              Deral 'percX' Heiland                 #
######################################################
package MP0006;
sub MP0006
{
 
# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


#-----Open output file for loging 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
print "\n**********Attempting to enumerate Job Account Record Xerox Phaser7750 printer $TARGET : JOB MP0006**********\n";
print OUTFILE "\n**********Attempting to enumerate Job Account Records  Xerox Phaser7750 printer $TARGET : JOB MP0006**********\n";

#----- Download of Job Account Record
my $browser = LWP::UserAgent->new(timeout => 15);
my $response = $browser->get("http$web://$TARGET:$PORTS/jobacct.dat",);

#----- Open jobacct.dat file for output of record information
open(JOBACCTOUTFILE, ">>./$OUTPUT/$TARGET-$PORTS-jobacct.dat") || die("Failed to open  Output file $TRAGET-$PORTS-jobacct.dat \n");
print JOBACCTOUTFILE $response->content;
print "********** Download of Job Account Record completed. File is saved as $TARGET-$PORTS-jobacct.dat **********\n";
print OUTFILE "********** Download of Job Account Record completed. File is saved as $TARGET-$PORTS-jobacct.dat **********\n";

#----- operation completed close out output files
close(OUTFILE);
close(JOBACCTOUTFILE);
}
1;
