# IBM TS3310 Tape Library System default password test
# 
######################################################
#                  PRAEDO Module #MA0006             #
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
package MA0006;
sub MA0006
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on  IBM TS3310 Tape Library System Device $TARGET : JOB MA0006**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on  IBM TS3310 Tape Library System Device $TARGET : JOB MA0006**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);
my $response = new HTTP::Request GET =>"http$web://$TARGET:$PORTS/";
# Test  For Default Password
my $response = $browser->post("http$web://$TARGET:$PORTS/index.htm",
[
"authType" => "local",
"username" => "service",
"password" => "ser001",
"auth" => "local",
"domain" => "",
]);
     
#authType=local&username=service&password=ser001&auth=local&domain= 

my $content = $response->content();
my $data = $response->header("Location");
# print $data;

if ($data =~ /main_IBM3576.htm/)
        {
            print "SUCCESS : username=service : password=ser001\n";
            print OUTFILE "SUCCESS : username=service : password=ser001\n";
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
