# Netopia 3347 modem SNMP data extract  
# 
######################################################
#                  PRAEDO Module #MA0020             #
#          Copyright (C) 2014 	 layereddefense.com  #
#              Deral Heiland    "@percent_x"         # 
######################################################
package MA0020;
sub MA0020
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to extract wifi settings via snmp from $TARGET : JOB MA0020**********\n";

# setup SNMP session
($session,$error) = Net::SNMP->session(Hostname => $TARGET, Community => public);

# test to see if wifi is enabled or disabled
$wificheck = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.1.0");
my $wifistatus = $wificheck->{"1.3.6.1.4.1.304.1.3.1.26.1.1.0"};
        if ($wifistatus == 1)
            {
            print OUTFILE "Wifi is enabled on this device\n";
            }

        elsif ($wifistatus == 2)
            {
             print OUTFILE "Wifi is disabled on this device\n";
            }


# Test device for wifi security type enabled
$result = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.9.1.4.1");
my $wifisec = $result->{"1.3.6.1.4.1.304.1.3.1.26.1.9.1.4.1"};

#extract SSID name
$ssidname = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.9.1.2.1");
print OUTFILE "SSID: ".$ssidname->{"1.3.6.1.4.1.304.1.3.1.26.1.9.1.2.1"}."\n";

# pull wifi security keys based on device setup
        if ($wifisec == 1)
            {
            print "SUCCESS\n";
            print OUTFILE "Device is configured with OPEN access wifi\n";
            }

        elsif ($wifisec == 2)
            {
             print "SUCCESS\n";
 	     print OUTFILE "Device is configured for WEP Manual - Factory default setting\n";
            # extract WEP KEY info
                my $wepkey1 = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.1");
                my $wepkey2 = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.2");
                my $wepkey3 = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.3");
                my $wepkey4 = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.4");
                my $actkey = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.13.0");
                print OUTFILE "WEP kEY1: ".$wepkey1->{"1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.1"}."\n";
                print OUTFILE "WEP kEY2: ".$wepkey2->{"1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.2"}."\n";
                print OUTFILE "WEP kEY3: ".$wepkey3->{"1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.3"}."\n";
                print OUTFILE "WEP kEY4: ".$wepkey4->{"1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.4"}."\n";
                print OUTFILE "The current active key is: ".$actkey->{"1.3.6.1.4.1.304.1.3.1.26.1.13.0"}."\n";

            }
        elsif ($wifisec == 3)
            {
            print "SUCCESS\n"; 
            print OUTFILE "Device is configured for WEP Automatic\n";
            # extract WEP KEY info
                my $wepkey = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.1");
                print OUTFILE "WEP kEY: ".$wepkey->{"1.3.6.1.4.1.304.1.3.1.26.1.15.1.3.1"}."\n";
            }
	elsif ($wifisec == 4)
            {
	    print "SUCCESS\n";
            print OUTFILE "Device is configured for WPA\n";
	    # extract WPA PSK info
		my $wpapsk = $session->get_request("1.3.6.1.4.1.304.1.3.1.26.1.9.1.5.1");
		print OUTFILE "WPA PSK: ".$wpapsk->{"1.3.6.1.4.1.304.1.3.1.26.1.9.1.5.1"}."\n";

            }
        elsif ($wifisec == 5)
            {
	    print "SUCCESS\n"; 
            print OUTFILE "Device is configured for WPA 802.1x no usable wifi data extracted\n";
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
