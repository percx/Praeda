# ARRIS / Motorola SBG6580 Cable Modem SNMP data extract  
# NOTE: module quickly hacked together for demonstration
#
######################################################
# PRAEDO Module #MA0024                              #
# Matthew Kienow @ inokii.com                        #
######################################################
package MA0024;
sub MA0024
{

  # Set global variables
  my $TARGET = $_[1];
  my $PORTS = $_[2];
  my $web = $_[3];
  my $OUTPUT = $_[4];
  my $LOGFILE = $_[5];


  # open output file
  open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
  print "\n**********Attempting to extract wifi settings via snmp from $TARGET : JOB MA0024**********\n";

  # setup SNMP session
  ($session, $error) = Net::SNMP->session(Hostname => $TARGET, Community => public);

  # attempt to get the username and password for the device user interface
  # using the CableHome cabhPsDevMib MIB module which defines the
  # basic management objects for the Portal Services (PS) logical element
  # of a CableHome compliant Residential Gateway device
  my $deviceUiSelection = $session->get_request("1.3.6.1.4.1.4491.2.4.1.1.6.1.3.0");
  if ($deviceUiSelection == 1)
  {
    # manufacturerLocal(1) - indicates Portal Services is using the vendor
    # web user interface shipped with the device
    my $deviceUiUsername = $session->get_request("1.3.6.1.4.1.4491.2.4.1.1.6.1.1.0");
    print OUTFILE "Device UI Username: ".$deviceUiUsername->{"1.3.6.1.4.1.4491.2.4.1.1.6.1.1.0"}."\n";

    my $deviceUiPassword = $session->get_request("1.3.6.1.4.1.4491.2.4.1.1.6.1.2.0");
    print OUTFILE "Device UI Password: ".$deviceUiPassword->{"1.3.6.1.4.1.4491.2.4.1.1.6.1.2.0"}."\n";
  }
  
  # test if wifi is enabled or disabled
  my $wificheck = $session->get_request("1.3.6.1.2.1.2.2.1.8.32");
  my $wifistatus = $wificheck->{"1.3.6.1.2.1.2.2.1.8.32"};
  if ($wifistatus == 1)
  {
    print OUTFILE "WiFi is enabled on this device\n";
  }
  else
  {
    print OUTFILE "WiFi is disabled on this device\n";
  }

  # extract SSID name
  $ssidname = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.1.14.1.3.32");
  print OUTFILE "SSID: ".$ssidname->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.1.14.1.3.32"}."\n";

  # check device wifi security type
  $result = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.1.14.1.5.32");
  my $wifisec = $result->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.1.14.1.5.32"};

  # pull wifi security keys based on device setup
  if ($wifisec == 0)
  {
    print "SUCCESS\n";
    print OUTFILE "Device is configured with Network Authentication Mode: Open Security\n";
  }
  elsif ($wifisec == 1 || $wifisec == 6)
  {
    print "SUCCESS\n";
    my $wepName = "WEP";
    if ($wifisec == 6)
    {
      $wepName = "WEP 802.1x Authentication";
    }

    my $wepEncryption = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.1.1.2.32");
    if ($wepEncryption == 1)
    {
      print OUTFILE "Device is configured with Network Authentication Mode: $wepName (64-bit)\n";
      my $wepkey1 = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.2.1.2.32.1");
      my $wepkey2 = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.2.1.2.32.2");
      my $wepkey3 = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.2.1.2.32.3");
      my $wepkey4 = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.2.1.2.32.4");
      print OUTFILE "WEP Key1: ".$wepkey1->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.2.1.2.32.1"}."\n";
      print OUTFILE "WEP Key2: ".$wepkey2->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.2.1.2.32.2"}."\n";
      print OUTFILE "WEP Key3: ".$wepkey3->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.2.1.2.32.3"}."\n";
      print OUTFILE "WEP Key4: ".$wepkey4->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.2.1.2.32.4"}."\n";
    }
    elsif ($wifisec == 2)
    {
      print "SUCCESS\n";
      print OUTFILE "Device is configured with Network Authentication Mode: $wepName (128-bit)\n";
      my $wepkey1 = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.3.1.2.32.1");
      my $wepkey2 = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.3.1.2.32.2");
      my $wepkey3 = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.3.1.2.32.3");
      my $wepkey4 = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.3.1.2.32.4");
      print OUTFILE "WEP Key1: ".$wepkey1->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.3.1.2.32.1"}."\n";
      print OUTFILE "WEP Key2: ".$wepkey2->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.3.1.2.32.2"}."\n";
      print OUTFILE "WEP Key3: ".$wepkey3->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.3.1.2.32.3"}."\n";
      print OUTFILE "WEP Key4: ".$wepkey4->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.3.1.2.32.4"}."\n";
    }
    my $actkey = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.1.1.1.32");
    print OUTFILE "The current active key is: ".$actkey->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.1.1.1.32"}."\n";

    if ($wifisec == 6)
    {
      # TODO: move to method
      my $radiusServer = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.2.32");
      print OUTFILE "RADIUS Server (hex): ".$radiusServer->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.2.32"}."\n";

      my $radiusPort = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.3.32");
      print OUTFILE "RADIUS Port: ".$radiusPort->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.3.32"}."\n";

      my $radiusKey = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.4.32");
      print OUTFILE "RADIUS Key: ".$radiusKey->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.4.32"}."\n";
    }
  }
  elsif ($wifisec == 2 || $wifisec == 3 || $wifisec == 7 || $wifisec == 4 || $wifisec == 5 || $wifisec == 8)
  {
    print "SUCCESS\n";
    my $authName = "WPA-PSK/WPA2-PSK";
    my $radius = 0;
    if ($wifisec == 4 || $wifisec == 5 || $wifisec == 8)
    {
      $authName = "WPA/WPA2 RADIUS";
      $radius = 1;
    }
    print OUTFILE "Device is configured with Network Authentication Mode: $authName\n";
    my $wpaPsk = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.4.1.2.32");
    print OUTFILE "WPA PSK: ".$wpaPsk->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.4.1.2.32"}."\n";
    if ($radius)
    {
      # TODO: move to method
      my $radiusServer = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.2.32");
      print OUTFILE "RADIUS Server (hex): ".$radiusServer->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.2.32"}."\n";

      my $radiusPort = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.3.32");
      print OUTFILE "RADIUS Port: ".$radiusPort->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.3.32"}."\n";

      my $radiusKey = $session->get_request("1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.4.32");
      print OUTFILE "RADIUS Key: ".$radiusKey->{"1.3.6.1.4.1.4413.2.2.2.1.5.4.2.5.1.4.32"}."\n";
    }
  }
  else
  {
    print "FAILED\n";
    print OUTFILE "FAILED\n";
  }

  # operation completed close out output files and snmp sessions
  $session->close;
  close(OUTFILE);
}
1;
