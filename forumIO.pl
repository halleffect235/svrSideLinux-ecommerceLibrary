#!/home/akassoc/localperl/bin/perl5.30.0
#
# Library Locations Here
use lib '/home/akassoc/localperl/lib/5.30.0';
use lib '/home/akassoc/cgi-bin/^Library';
#
# Key features and requirements
#use strict;
#use warnings;

#use akaRoutines;
#use fileHandling;
use forumHandling;

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

if($process eq 'getForumLast_V') {

	$data{result} = forumHandling::getForumLast_V();
	#$data{result} = "forum post list... jpl";

}


	print $q->header('application/json');
	print to_json(\%data);
	exit 0;
