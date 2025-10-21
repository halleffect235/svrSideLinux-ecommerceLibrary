#!/home/akassoc/localperl/bin/perl5.30.0
#
# Library Locations Here
use lib '/home/akassoc/localperl/lib/5.30.0';
use lib '/home/akassoc/cgi-bin/^Library';

use imageHandling;
#
#
# Perl libraries here
use CGI;
use JSON;
use Template;

#
# cgi parameters
	my $q = new CGI;
	my %data;
# 
# get our input partameters
	my $process 	= $q->param('process');
#
# if our process is get image dimension
	if($process eq "getImageDimensions") {
		my $parms	= '';		
		my $image	= $q->param('imageFile');
		my $returnParms = imageHandling::imageDimensions($image);

		$parms = @$returnParms[0] . ',' . @$returnParms[1] . ',' . @$returnParms[2];
		$data{result} = $parms;
	}
#
# return our parameters
	print $q->header('application/json');
	print to_json(\%data);
	exit 0;

