#!/home/akassoc/localperl/bin/perl5.30.0
#
#
# Library Locations Here
use lib '/home/akassoc/localperl/lib/5.30.0';
use lib "/home/akassoc/cgi-bin/^Library";

use strict;
use CGI qw(:all);


package stringHandling;

sub str_checkEmail {
	my $chkStrn = $_[0];
	$chkStrn =~	s/[a-zA-Z0-9\-\_\~\!\$\&\'\(\)\*\+\,\;\=\:\@\.]+//g;

	if($chkStrn eq "") {return(0)};
	return(-1);
}


sub str_checkName {
	my $chkStrn = $_[0];
	$chkStrn =~	s/[a-zA-Z0-9\-\_\&\'\.]+//g;

	if($chkStrn eq "") {return(0)};
	return(-1);
}


sub str_CheckUserName {
	my $chkStrn = $_[0];
	$chkStrn =~ s/([\w\.\-]+)//g;

	if($chkStrn eq "") {return(0);}
	return(-1);
}


sub str_CheckUserPassword {
	my $chkStrn = $_[0];
	$chkStrn =~ s/[\w+\[\]\{\}\@\#\!]+//g;

	if($chkStrn eq "") {return(0);}
	return(-1);
}


sub str_FixName {	
	my $fixStr = $_[0];
	my $len = length($fixStr);
	my $indx = 0;
#	$fixStr =~ /([\w-_&'\.]*)/;
	my $str = "";
	while( $indx < $len) {
		$_ = substr($fixStr, $indx++, 1);
		m/([\w-_&'\.]*)/;
		if($1 ne "\0") {$str .= $1;} $_ = "\0"; m/(\0)/;
 
	}
	
	return($str);
}


sub str_FixNumber {
	my $fixStr =$_[0];
	$fixStr =~ s/\D+//g;
	return($fixStr);
}


sub str_FixEmail {
	my $fixStr = $_[0];
#	$fixStr =~	m/([a-zA-Z0-9\-\_\~\!\$\&\'\(\)\*\+\,\;\=\:\@\.]+)/;

	return($fixStr);
}


sub str_FixComment {
#	$fixStr =~ m/([\ 0-9a-zA-z\'\&\_\-\:\;\,\.\+\*\!])/;
#

	my $fixStr = $_[0];
	my $len = length($fixStr);
	my $indx = 0;
	my $str = "";
	while( $indx < $len) {
		$_ = substr($fixStr, $indx++, 1);
		m/([\ \w\'\&\_\-\:\;\,\.\+\*\!])/;
		if($1 ne "\0") {$str .= $1;} $_ = "\0"; m/(\0)/;
	}
	
	return($str);
}

1;