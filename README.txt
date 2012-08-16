This file is used to list a few config items and recommendation. Also some basic Praeda syntax 


Required perl modules:
LWP::Simple
LWP::UserAgent
HTML::TagParser
URI::Fetch
HTTP::Cookies
IO::Socket
HTML::TableExtract
use Getopt::Std;
also it is advised to install "Crypt::SSLeay or  IO::Socket::SSL" for ssl support

set root of praeda install in praeda.pl under
my $dirpath =".";





Praeda version 0.02.0.b syntax:

PRAEDA OPTIONS:
-g GNMAP_FILE
-t TARGET_FILE
-p TCP_PORT
-j PTOJECT_NAME
-l OUTPUT_LOG_FILE
-S SSL

GNMAP_FILE = This is a .gnmap file output by a nmap scan.
TARGET_FILE = List of IP addresses or Host names to enumerated
TCP_PORT = port address of targets to scan " At present only one port can be specified. This is expected to be modified in future version"
PROJECT_NAME = the name for this project. This will create a folder under the folder where Praeda was executed to contain logs and export info.
OUTPUT_LOG_FILE = name of log file for data output


SYNTAX FOR GNMAP FILE INPUT:
praeda.pl -g GNMAP_FILE -j PROJECT_NAME -l OUTPUT_LOG_FILE


SYNTAX FOR IP TARGET FILE LIST:
praeda.pl -t TARGET_FILE -p TCP_PORT -j PROJECT_NAME -l OUTPUT_LOG_FILE -s SSL 
 

Examples:

./praeda.pl -g scan1.gnmap -j acmewidget -l results

./praeda.pl  -t target.txt -p 80  -j project1 -l data-file

./praeda.pl  -t target.txt -p 443  -j project1 -l data-file -s SSL




The results will create a folder called project1 and save all information in that folder. Also this will write out the following data.
targetdata.txt  : This is the parsed results of .gnmap file
$LOGFILE-WebHost.txt : This is an output of all webservers querried listing IP:PORT:TITLE:SERVER
$LOGFILE.log : This file will contain the results of the modules executed.
RAW extract data including: Clones, Backups, Address Books ect...

****WARNING**** 
Also insure that your local firewall is turned off. Certain modules that require connection back to host system for the module to run correctly.
