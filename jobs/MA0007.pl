# Eaton Connect UPS SNMP trap settings
######################################################
#                  PRAEDO Module #MA0007             #
#          Copyright (C) 2010 Foofus.net	     #
#                  ___     ,--,                      # 
#                 /  .\   / .`|                      # 
#                 \  ; | /' / ;                      # 
#                  `--" /  / .'                      # 
#                      /  / ./   ,--,  ,--,          # 
#                     / ./  /    |'. \/ .`|          # 
#                    /  /  /     '  \/  / ;          # 
#                   /  /  /       \  \.' /           # 
#                  ;  /  / ___     \  ;  ;           # 
#                ./__;  / /  .\   / \  \  \          # 
#                |   : /  \  ; |./__;   ;  \         # 
#                ;   |/    `--" |   :/\  \ ;         # 
#                `---'          `---'  `--`          #
#              Deral Heiland    "percX"              # 
######################################################
package MA0007;
sub MA0007
{
 
# Set global variables
my $TARGET = $_[1];
my $PORTS = $_[2];
my $web = $_[3];
my $OUTPUT = $_[4];
my $LOGFILE = $_[5];
my $num = 2;


# Open output file and setup browser LWP function 
open(OUTFILE, ">>./$OUTPUT/$LOGFILE.log") || die("Failed to open  Output file $LOGFILE.log \n");
print "\n**********Attempting to enumerate SNMP trap settings from Eaton Connect UPS at $TARGET : JOB MA0001**********\n";
print OUTFILE "\n**********Attempting to enumerate Eaton Connect UPS SNMP trap settings for $TARGET are:\n";


# parse snmp setup data from page information on input tags TD
my $html = HTML::TagParser->new( "http$web://$TARGET:$PORTS/PTrap.html" );
    my @list = $html->getElementsByTagName( "TD" );
    foreach my $elem ( @list )
{
        my $text = $elem->innerText;
          if (( $text eq "public" ) && ($num eq $count))
               {
                $num = $num+5;
               }
          else
               {
                  if ($num eq $count)
                     {
                       print "$text\n";
                       print OUTFILE "$text\n";
                       $num = $num+5;
                     }
                  else
                    {
                    }
             }
        $count = $count+1;
}

# operation completed close out output files
close(OUTFILE);

}
		
1;
