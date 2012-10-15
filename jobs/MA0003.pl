# Stallion easy server II default password test
# 
######################################################
#                  PRAEDO Module #MA0003             #
#          Copyright (C) 2010 Foofus.net	     #
#                  ___     ,--,                      # 
#                 /  .\   / .`|                      # 
#                 \  ; | /' / ;                      # 
#                  `--" /  / .'                      # 
#                      /  / ./   ,--,  ,--,          # 
#                     / ./  /    |'. \/ .`|          # 
#                    /  /  /     '  \/  / ;          # 
#                   /  /  /       \  \.' /           # 
#                  ;  /  / ___     \  ;  ;           # 
#                ./__;  / /  .\   / \  \  \          # 
#                |   : /  \  ; |./__;   ;  \         # 
#                ;   |/    `--" |   :/\  \ ;         # 
#                `---'          `---'  `--`          #
#              Deral Heiland    "percX"              # 
######################################################
package MA0003;
sub MA0003
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on Stallion easy server II Device $TARGET : JOB MA0003**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on Stallion easy server II Device $TARGET : JOB MA0003**********\n";

my $browser = LWP::UserAgent->new(timeout => 120);
$browser->default_header(Authorization=> "Basic cm9vdDpzeXN0ZW0=");


# Test  For Default Password

     my $response = $browser->get("http$web://$TARGET:$PORTS/setup.html",);

my $content = $response->content();
     
if ($content =~ /EasyServer II - Setup/)
        {
            print "SUCCESS : username=root : password=system\n";
            print OUTFILE "SUCCESS : username=root : password=system\n";
        }
        else 
        { 
           print "FAILED \n";
           print OUTFILE "FAILED \n";
        } 


# operation completed close out output files
close(OUTFILE);

}
		
1;
