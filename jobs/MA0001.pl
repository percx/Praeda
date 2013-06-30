# Riverbed Technology default password test
# 
######################################################
#                  PRAEDO Module #MA0001             #
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
package MA0001;
sub MA0001
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********--Attempting to verify default credentials on RiverBed Device $TARGET : JOB MA0001**********\n";
print OUTFILE "\n**********Verify default credentials on RiverBed Device $TARGET : JOB MA0001**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);

# Test  For Default Password

     my $response = $browser->get("http$web://$TARGET:$PORTS/mgmt/gui?P=home&loginUser=admin&loginPassword=password&loginButton=Log+In",);

my $content = $response->content();

if ($content =~ /User admin with the given password is not recognized/)
        {
            print "FAILED \n"; 
	    print OUTFILE "FAILED \n";
        }
        else 
        { 
            print "$TARGET : SUCCESS : username=admin : password=password\n";
            print OUTFILE "$TARGET : SUCCESS : username=admin : password=password\n";
        } 

                   

# operation completed close out output files
close(OUTFILE);

}
		
1;
