#!/home/akassoc/localperl/bin/perl5.30.0
#
# Library Locations Here
use lib '/home/akassoc/localperl/lib/5.30.0';
use lib '/home/akassoc/cgi-bin/^Library';
#
# Key features and requirements
#use strict;
#use warnings;
#
# Perl System Libraries
use CGI qw(:all);

#
# AKA System Libraries
use _globalFileNames;
use akaRoutines;
use memberHandling;
use edCryptLibrary;


#
package fileHandling;

sub readFile {

	my $memberFilename = $_[0]; $memberFilename =~ s/\/\//\//g;

	my $fC = "";

#	print $memberFilename;
#
#
#open and read member file
# return "-1" on error
#
		if(open(Dfile, $memberFilename)) {		
			while(<Dfile>) {$fC .= $_;};
			close(Dfile); 
			return($fC);
		} else {return("-1");}

		return($fC);
}

sub appendFile {

	my $memberFilename = $_[0]; $memberFilename =~ s/\/\//\//g;
	my $fC = $_[1];
	my $status = -1;
#
#
#	
	if(open(Dfile, '>>' . $memberFilename)) {		
		print Dfile $fC;
		close(Dfile); 
		$status = 0;
	} else {$status = -1;}

	return($status);

}



sub writeFile {

	my $fNm		= $_[0]; $fNm =~ s/\/\//\//g;
	my $fC		= $_[1];
	my $status	= -1;
#
#
#	
	if(open(Dfile, '>' . $fNm)) {		
		print Dfile $fC;
		close(Dfile); 
		$status = 0;
	}

	return($status);
}



#
#
# GetBasename - delivers filename portion of a fullpath.
#
#
# 2021-12-01 - jpl updated for efficiency, original code commented out
#

sub fh_getbaseFilename {
	my $fullname	= $_[0];
	$fullname =~ s/.*\\//;
	$fullname =~ s/.*\///;
#
	return($fullname);
}




sub fh_fileUpload {
#
#
# 2021-12-01 - jpl added code to handle if there is no home directory in output file path
#                  add proper file destination to correct
#

	my $iFile = $_[0];
	my $oFile = $_[1];
	my $inBuffer = ""; my $tBytes = 0; my $nBytes = 0;

	$_ = $oFile;
	if(!/home/) {$oFile = '/home/akassoc/' . $oFile;}
	$oFile =~ s/\/\//\//g;

	fileHandling::appendFile(_globalFileNames::generalLogging(), akaRoutines::formatTime() . "     fileHandling::fh_fileupload: upload filename: $iFile, server file name: $oFile \n");

#
# We are going to use the scalar $upfile as a filehandle,
# but perl will complain so we turn off ref checking.
# The newer CGI::upload() function obviates the need for
# this. In new versions do $fh = $cgi->upload('upfile'); 
# to get a legitimate, clean filehandle.
#
	no strict 'refs';
#
# create output file 
#
	if (! open(Ofile, '>' . $oFile) ) 
		{return(-1);}
#
#
# Consider everything binary

	binmode($iFile);

	while ($nBytes = read($iFile, $inBuffer, 1024) ) {
		print Ofile $inBuffer;
		$tBytes += $nBytes;
	}
	close(Ofile);

	return($tBytes);
}

sub fh_createDirectory {

	my $pth = $_[0];
	my $idx = 0;
	my @splits;
	my $cPth = '';

	$pth .= '/';
	$pth =~ s/\s//g;		# remove whitespace
	$pth =~ s/\/\//\//g;		# remove double //s
	$pth =~ s/\/$//;		# remove last /

	$_ = $pth;
	@splits = split(/\//);		# split directory path into segments

	$idx = @splits;

	$cPth = $splits[$idx - 1];	# get last segment [one we need to create]
	$pth =~ s/$cPth//;		# remove last directory

	chdir($pth);			# cd to path
        mkdir($cPth, 0700); 		# create our new directory
	return($pth);
}


sub fh_readDirectory {

	my $dir	= $_[0];
	my $buildStr 	= "";

	my @files	= "";
	my $idx 	= 0;
	my $tStr 	= "";

#
#
#	print $dir, ", directory passed in"; exit 0;

	if(! opendir(fh_dH, $dir) ) {
		#print "Could not open for reading \n";
		#exit 0;
	}


    	while ($_ = readdir fh_dH) {
       	if(!/^\.$/ && ! /^\.\.$/) {$buildStr .= $_ . "\n";}
	}

	$buildStr =~ s/\n$//;

	closedir(fh_dH);
#
	return($buildStr);

}


sub fh_moveFile {

	my $src = $_[0]; $src =~ s/\/\//\//g;
	my $dst = $_[1]; $dst =~ s/\/\//\//g;

	my $fc  = '';
	my $st  = -1;

	#fileHandling::appendFile(_globalFileNames::generalLogging(), akaRoutines::formatTime() . "     fileHandling::fh_movefile, src: $src\n");
	#fileHandling::appendFile(_globalFileNames::generalLogging(), akaRoutines::formatTime() . "     fileHandling::fh_movefile, dst: $dst\n");
#
#
#	
	$fc = fileHandling::readFile($src);
	if($fc ne "-1") {
		fileHandling::writeFile($dst, $fc);
		unlink $src;
		$st = 0;
	}
	return($st);

}



#
#
# create a random string to be used as a filename

sub randomString {

	my $chars = $_[0];
	my $rString="";
	my $idx;

	if($chars <= 0 || $chars eq "") {$chars = 6;}


	for($idx = 0; $idx < $chars; $idx++) {$rString .= akaRoutines::randomChar();}

	return($rString);
}

sub createBaseFileName {

		my $email = $_[0];

		my $rndStr = randomString(10);

		my $dtime = akaRoutines::formatTime();

		return($dtime . '|' . $rndStr . '|' . $email);

}

sub readFileEncrypt {

	my $memberFilename	= $_[0];
	my $fC = "";
#
#
#open and read member file
# return "-1" on error
#
	$fC  = edCryptLibrary::decFile($memberFilename);

	return($fC);
}


sub writeFileEncrypt {

	my $fileName	= $_[0];
	my $fC		= $_[1];

	edCryptLibrary::encFile($fileName, $fC);
}


sub appendFileEncrypt {

	my $memberFilename	= $_[0];
	my $appendCt		= $_[1];
	my $fC = "";
#
#
#open and read member file
# return "-1" on error
#
	$fC  = edCryptLibrary::decFile($memberFilename);
	if($fC eq '-1') {$fC = '';}
	$fC .= $appendCt;

	$status = edCryptLibrary::encFile($memberFilename, $fC);
	return($status);
}

sub testEncKey {

 		my $encCode = $_[0];
		my $fC = "";
		my @splitC;
		my $indx = 0;

		if(length($encCode) < 12 || $encCode eq "") {
			return(-1);
		}

		$fC = fileHandling::readFileEncrypt('/home/akassoc/!logging/~aka/~member/~encKeys.log');

		$_ = $fC;

		@splitC = split("\n");

		for($indx = 0; $indx < @splitC; $indx++) {

			$_ = $splitC[$indx];

			if(/$encCode/) {
				return(0);
			} 
		}

		return(-1);

	}

1;


