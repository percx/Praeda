# Canon printer 3XXX Series Module for enumerating 
# E-mail/I-Fax Settings.
######################################################
#                  PRAEDO Module #MP0003             #
#          Copyright (C) 2010 Foofus.net	     #
#             Deral "percX" Heiland                  #
######################################################
package MP0003;
sub MP0003 
{
 
# Set global variables
my $count = 0;
my $num = 11;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
print "\n**********Attempting to enumerate E-mail/I-Fax Settings for Cannon printer $TARGET : Job MP0003**********\n";
print OUTFILE "\n**********Attempting to enumerate E-mail/I-Fax Settings for Cannon printer $TARGET : Job MP0003**********\n";




my $browser = LWP::UserAgent->new(timeout => 15);

# Setup and retrieve cookie and place in cookie jar
my $jar = HTTP::Cookies->new();
$browser->cookie_jar($jar);
my $req= new HTTP::Request GET =>"http://$TARGET:$PORTS/";
my $res = $browser->request($req);
$jar->extract_cookies($res);

# retrieve E-mail/I-Fax Settings form page from cannon printer
my $url1="http://$TARGET:$PORTS/cdnetwork.cgi?Flag=Init_Data&PageFlag=c_d_rnet.tpl";
my $request = new HTTP::Request('GET', $url1);
my $response = $browser->request($request);
my $content = $response->content();

# parse E-mail/I-Fax Settings form page information on input tags
my $html = HTML::TagParser->new($content);
my @list = $html->getElementsByTagName( "input" );
    foreach my $elem ( @list ) 
   {

        my $text1 = $elem->getAttribute("name");
        my $text2 = $elem->getAttribute("value");
            
          if (( $text1 eq "" ) && ($num eq $count)) 
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
