Praeda is an automated data/information harvesting tool. Originally designed to extract data from Multi Function Printers (MFP), but since has been expanded to include all embedded devices. Praeda leverages weak password and vulnerabilities in embedded devices to extract data such as username, passwords and SNMP community strings.This data is extracted via the web management console and SNMP on most devices.


This file is used to list a few config items and recommendation. Also some basic Praeda syntax 


Required perl modules:
LWP::Simple
LWP::UserAgent
HTML::TagParser
URI::Fetch
HTTP::Cookies
IO::Socket
HTML::TableExtract
Getopt::Std
Net::SSL
Net::SNMP
NetAddr::IP;

Windows Install Note: If running on Windows host and having issues install Net:SSL with cpan. Change the following in praeda.pl "use Net::SSL" to "use Net::SSLeay" and run the following install for Net-SSLeay.ppd:
ppm install http://http://cpansearch.perl.org/src/MIKEM/Net-SSLeay-1.46/Net-SSLeay.ppd --force


Linux Install Note: If you have issues installing Net::SSL on linux getting the following error "SSLeay.xs:35:25: fatal error: openssl/ssl.h: No such file or directory"
You will need to install the libssl-dev "apt-get install libssl-dev"


set root of praeda install in praeda.pl under
my $dirpath =".";



Praeda version 0.02.2.089b syntax:
first part of version  0.02.2 represent the core product version the Last 3 digits represent the number of product versions tested.

PRAEDA OPTIONS:
-g GNMAP_FILE
-n CIDR or CIDR_FILE 
-t TARGET_FILE
-p TCP_PORT
-j PTOJECT_NAME
-l OUTPUT_LOG_FILE
-S SSL

GNMAP_FILE = This is a .gnmap file output by a nmap scan.
CIDR & CIDR_FILE = Subnet CIDR "192.168.1.0/24" or file containing list of CIDRs
TARGET_FILE = List of IP addresses or Host names to enumerated
TCP_PORT = port address of targets to scan " At present only one port can be specified. This is expected to be modified in future version"
PROJECT_NAME = the name for this project. This will create a folder under the folder where Praeda was executed to contain logs and export info.
OUTPUT_LOG_FILE = name of log file for data output


SYNTAX FOR GNMAP FILE INPUT:
praeda.pl -g GNMAP_FILE -j PROJECT_NAME -l OUTPUT_LOG_FILE

SYNTAX FOR IP  CIDR/CIDR FILE LIST:
praeda.pl -t CIDR or CIDR_FILE -p TCP_PORT -j PROJECT_NAME -l OUTPUT_LOG_FILE -s SSL


SYNTAX FOR IP TARGET FILE LIST:
praeda.pl -t TARGET_FILE -p TCP_PORT -j PROJECT_NAME -l OUTPUT_LOG_FILE -s SSL 
 

Examples:

./praeda.pl -g scan1.gnmap -j acmewidget -l results

./praeda.pl  -n 10.10.10.0/24 -p 80  -j project1 -l data-file

./praeda.pl  -n cidrs.txt -p 80  -j project1 -l data-file

./praeda.pl  -t target.txt -p 80  -j project1 -l data-file

./praeda.pl  -t target.txt -p 443  -j project1 -l data-file -s SSL


NOTE: The -n option has a limit on networks of 65535 so cidr mask less the /16 will error out with "netmask error: overrange". This is a limitation of the module NetAddr::IP.


The results will create a folder called project1 and save all information in that folder. Also this will write out the following data.
targetdata.txt  : This is the parsed results of .gnmap file
$LOGFILE-WebHost.txt : This is an output of all webservers querried listing IP:PORT:TITLE:SERVER
$LOGFILE.log : This file will contain the results of the modules executed.
RAW extract data including: Clones, Backups, Address Books ect...

****WARNING**** 
Also insure that your local firewall is turned off. Certain modules that require connection back to host system for the module to run correctly.
