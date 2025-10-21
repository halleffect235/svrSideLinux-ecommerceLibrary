#!/home/akassoc/localperl/bin/perl5.30.0
#
# Library Locations Here
use lib '/home/akassoc/localperl/lib/5.30.0';
use lib '/home/akassoc/cgi-bin/^Library';

use akaRoutines;
use olsHandling;

#
#
# Perl libraries here

use CGI;
use JSON;
use Template;

#
# CGI interface variables here

my $q = new CGI;
my %data;

my $process = $q->param('process');
#
#
#
if($process eq 'inventoryTotals') {

	my $idx = 0;
	my $oStr = '';
	$_ = $q->param('itemList');

	my @sList = split(/\n/);
	for($idx = 0; $idx < @sList; $idx++) {$oStr .= olsHandling::getItemCount($sList[$idx]) . "\n";}

	$data{result} = $oStr;

	print $q->header('application/json');
	print to_json(\%data);

	exit 0;
}


1;	
