#!/usr/bin/perl
#
# praeda.pl
# praeda [robber, plunderer]. 
#   
#
# PRAEDA version 0.02.0.0b
######################################################
#                    PRAEDA                          #
#        Copyright (C) 2010 Foofus.net		     #
#              Deral 'percX' Heiland                 #
######################################################
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; version 2
#  of the License only.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# Contact Information:
#       dh@layereddefense.com
#       http://www.foofus.net & http://layereddefense.com
#######################################################################
# See the README.txt and/or help files for more information on how to use & config.
# See the LICENSE.txt file for more information on the License PRAEDO is distributed under.
#
# This program is intended for use in an authorized manner only, and the author
# can not be held liable for anything done with this program, code, or items discovered
# with this program's use.
#######################################################################
use LWP::Simple;
use LWP::UserAgent;
use HTML::TagParser;
use URI::Fetch;
use HTTP::Cookies;
use IO::Socket ();
use HTML::TableExtract;
use Getopt::Std;

# -- Set Variables ---------------
my $dirpath =".";
my $DataEntry ="";
my $number = "";
my $title = "";
my $server = "";
my $job = "job";  
my $web = "";
my $SOCKET_IS_UP = 0;
my $SOCKET_IS_DOWN = 1;
my $REQUEST_TIMEOUT = 5;
my $WAIT_FOR_RST = 1;
my $TARGET = "";
my $PORTS = "";
my $OUTPUT = "";
my $LOGFILE = "";
my $FILE = "";

#set options
%options=();
getopts("g:t:p:j:l:s:",\%options);

#set option exclusions and messages
if ($options{g} && ($options{t} || $options{p})) {
  print"-g and -t or -p options are not allowed at same time\n";
  print"The correct options syntax are:\n";
  print"For .gnmap input: praeda.pl -g GNMAP_FILE -j PROJECT_NAME -l OUTPUT_LOG_FILE\n";
  print"For target list input: praeda.pl -t TARGET_FILE -p TCP_PORT -j PROJECT_NAME -l OUTPUT_LOG_FILE -s SSL \n";
  exit;
}
elsif ($options{g} && (!$options{j} || !$options{l})) {
  print"Options -j and -l are both required when using option -g\n";
  print"The correct options syntax for using .gnmap as input is:\n";
  print"praeda.pl -g GNMAP_FILE -j PROJECT_NAME -l OUTPUT_LOG_FILE\n";
  exit;  
}
elsif ($options{t} && (!$options{p} || !$options{j} || !$options{l})) {
  print"Options -p, -j and -l are all required when using option -t\n";
  print"The correct options syntax for using target ip list file as input is:\n";
  print"praeda.pl -t TARGET_FILE -p TCP_PORT -j PROJECT_NAME -l OUTPUT_LOG_FILE -s SSL \n";
  exit;  
}
elsif (!$options{g} && !$options{t} ) {
  print"Required options are missing\n";
  print"The correct options syntax are:\n";
  print"For .gnmap input: praeda.pl -g GNMAP_FILE -j PROJECT_NAME -l OUTPUT_LOG_FILE\n";
  print"For target list input: praeda.pl -t TARGET_FILE -p TCP_PORT -j PROJECT_NAME -l OUTPUT_LOG_FILE -s SSL \n";
  exit;  
}

# -- Import data_file----
my $data_file="$dirpath/data/data_list";
open(DAT, $data_file) || die("Could not open file!");
my @raw_data=<DAT>;
close(DAT);

# Enable -ssl and set to ignore invalid certs
if (($options{s} eq "ssl" ) || ($options{s} eq "SSL"))
        {
	$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'}=0;
	$web = 's';
        }

# Setup browser
my $browser = LWP::UserAgent->new;
$browser->cookie_jar({});
$browser->timeout(15);

# create project folder
mkdir "$options{j}", 0775 unless -d "$options{j}";


#setup and call gnmap input parser routine
if ($options{g}){
$GNMAPFILE = $options{g};
$OUTPUT = $options{j};
$NAME = $option{l};
&gnmap_parse($options{g}, $options{j}); #  ---DEBUG check the varables here and 3 lines above
}

#set variable from option input data
if ($options{t})
  {
  $FILE = "$options{t}";
  $PORTS = "$options{p}";
  }
else
  {
  $FILE = "./$options{j}/targetdata.txt";
  }
$OUTPUT = "$options{j}";
$LOGFILE = "$options{l}";



#Read target input data
open (FILE, "$FILE") || die("Unable to open: $FILE $!");

while (<FILE>)
	{
	if ($options{g})
             {
              chomp $TARGET;
              ($TARGET, $PORTS, $N) = split(/:/);
                if (($N =~ m/https/i) || ($N =~ m/ssl/i)){ $web = "s";}
		else {$web ="";}
              }
        else {
              $TARGET = $_;
              chomp $TARGET;
             }

# call port check subroutine 
	my ( $status ) = 
	check_port( $TARGET, $PORTS );


if ( $status == $SOCKET_IS_DOWN )
     {
      open(WEBFILE, ">>./$OUTPUT/$LOGFILE-WebHost.txt") || die("Failed to open  Output file $LOGFILE-webhost.txt \n");
      print "$TARGET:$PORTS:NO ANSWER RETURNED\n";
      print WEBFILE "$TARGET:$PORTS:NO ANSWER RETURNED\n";
      close(WEBFILE);
     }
# Target enumeration Section 
else
     {
     my $html = $browser->get("http$web://$TARGET:$PORTS/");
     my $data1 = $html->header("Title");
     $data1 =~ s/[^[:print:]]/ /g;  # replace nonprintable characters with spaces "added May 13 2011 percX"
     my $data2 = $html->header("Server");
     print "\n$TARGET:$PORTS:$data1:$data2\n";
     open(WEBFILE, ">>./$OUTPUT/$LOGFILE-WebHost.txt") || die("Failed to open  Output file $LOGFILE-webhost.txt \n");
     print WEBFILE "$TARGET:$PORTS:$data1:$data2\n";
     close(WEBFILE);                
            foreach $DataEntry (@raw_data)
               {
                chomp($DataEntry);
                my @values=split(/\|/,$DataEntry);
                  if (($data1 eq $values[1]) && ($data2 =~ $values[2]))
                     {
 		       my $num = $#values + 1;
                       for ($i=3;$i<$num;$i++)
			{
                          if ($values[$i] eq ""){}
                          else
                             {
                             open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
                             print OUTFILE "\n$TARGET:$PORTS:$data1:$data2\n";
			     $job = $values[$i];	
			     require "$dirpath/jobs/$values[$i].pl";
                             my $printpwn = $job->$job($TARGET,$PORTS,$web,$OUTPUT,$LOGFILE);
			     print "\n";
                             } 
			}

                                  
                    } 
                }
     }

}

#-----------------------------------------------subroutines------------------------------------------------------#

#tcp port check routine
 sub check_port {
  my ( $TARGET, $PORTS ) = @_;
  my $status = $SOCKET_IS_DOWN;
  my $socket = IO::Socket::INET->new(
    PeerAddr => $TARGET,
    PeerPort => $PORTS,
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


# gnmap parse and save routine
sub gnmap_parse {
        my ( $GNMAPFILE, $OUTPUT ) = @_;
	open(MYINPUTFILE, "$GNMAPFILE") || die("Failed to open gnmap file $GNMAPFILE \n");
	unlink("./$OUTPUT/targetdata.txt");

while(<MYINPUTFILE>)
{
    my @portspec = ();
    my @gnmap = ();
    next if ( /^\#/ );                                 		# skip comments
    next if ( /^\s*$/ );                			# skip blank lines
    next if ( /\tStatus: Down/ );       			# skip down hosts
    chomp;

# clean up the entry
    s!host:\s+!!i;                      			# Host:
    s!\s+\(\)\s+!:!g;                   			# missing hostname
    s!^(\d+\.\d+\.\d+\.\d+)\s+(\([\w\.\-\_]+\))\s*!$1:$2!; 	# IP (hostname) to IP:(hostname)
    s!ports: !:!i;                      			# "Ports"
        s!|.*!!;                        			# trailing garbage
    s!\t+Ign.*!!;                       			# "Ignored State"

# extract IP addresses and ports found
    my @row = split (/:/, $_, 3);
    my @portspec = split (/,/, $row[2]);
    
#save only ports marked "open" and contain http
    open(OUTFILE, ">>./$OUTPUT/targetdata.txt") || die("Failed to open  Output file targetdata.txt \n");
    for my $portspec ( @portspec )
	{
	   my @fields = split ( /\//, $portspec );
	   next unless (( $fields[1] =~ /open/i ) && ($fields[4] =~ m/http/i));
	   my $p = "$row[0]:$fields[0]:$fields[4]";
	   $p =~ s/ //;
           print OUTFILE "$p\n";
	}
    close (OUTFILE);
}
}
