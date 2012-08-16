# Firescope AMI default password test
# 
######################################################
#                  PRAEDO Module #MA0005             #
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
package MA0005;
sub MA0005
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to Verify default credentials on Firescope AMI Device $TARGET : JOB MA0005**********\n";
print OUTFILE "\n**********Attempting to Verify default credentials on Firescope AMI Device $TARGET : JOB MA0005**********\n";

my $browser = LWP::UserAgent->new(timeout => 15);
my $response = new HTTP::Request GET =>"http://$TARGET:$PORTS/";
# Test  For Default Password
my $response = $browser->post("http://$TARGET:8004/login",
[
"user_name" => "admin",
"password" => "password",
"login" => "Login",
"forward_url" => "/",
]);
     
# user_name=admin&password=password&login=Login&login=Login&forward_url=%2Fu

my $content = $response->content();

if ($content =~ /The credentials you supplied were not correct/)
        {
            print "FAILED \n";
            print OURFILE "FAILED \n";
        }
        else 
        { 
	   print "This modules has not been validated!\n";
	   print OUTFILE "This modules has not been validated!\n";
           print "Possible access with user=admin and password=password\n";
           print OUTFILE "Possible access with user=admin and password=password\n";
           print "Please validate and correct the if else code\n";
           print OUTFILE "Please validate and correct the if else code\n";
        } 


                   

# operation completed close out output files
close(OUTFILE);

}
		
1;
