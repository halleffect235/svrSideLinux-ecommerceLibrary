#!/home/akassoc/localperl/bin/perl5.30.0
#
# Library Locations Here
use lib '/home/akassoc/localperl/lib/5.30.0';
use lib '/home/akassoc/cgi-bin/^Library';
#
# Key features and requirements
#use strict;
#use warnings;
use fileHandling;
use memberHandling;


#
#
# Perl libraries here

use CGI;
use JSON;
use Template;
use File::Copy qw(copy);
use _globalFileNames;

my $activationCodesIssued	= _globalFileNames::activationCodesIssued();

#my $q = new CGI;
#my %data;

#
# cgi parameters
	my $q = new CGI;
	my %data;
#
# inpout parameters
	my $process	= '';
	

# 
# get our input partameters

	$process 	= $q->param('process');

# if our process is generate code
#

	if($process eq "generateCode") {

		my $str		= "";
		my $code	= "";
		my $indx	= 0;
		my $comment	= $q->param('comment');

		for($indx = 0; $indx < 8; $indx++) {$code .= akaRoutines::randomChar();}

		$str = $code . '|' . $comment . "\n";

		fileHandling::appendFile($activationCodesIssued, $str);

		$data{result} = $code;

	}

	if($process eq "readServerDirectory") {

		my $basePath = "/home/akassoc/";
		my $status	= "";
		my $path	= $q->param('dirPath');
		$_		= $path;

		if(!/home/ && !/var/) 
			{$path	= $basePath . $path;}
 		
		$path =~ s/\/\//\//g;

		$status = fileHandling::fh_readDirectory($path);
		$data{result} = $status;
        }


	if($process eq "createServerDirectory") {

		my $basePath = "/home/akassoc/";
		my $status	= "";
		my $path	= $q->param('dirPath');
		$_		= $path;

		if(!/home/) 
			{$path	= $basePath . $path;}
 		
		$path =~ s/\/\//\//g;

		$status = fileHandling::fh_createDirectory($path);
                chmod 0755, $path;
		$data{result} = $status;
        }


	if($process eq "readServerDirectoryDetails") {

		my $basePath	= "/home/akassoc/";
		my $path 	= $q->param('dirPath');
		my $status	= "";
		my $preF	= 'f|';
		my $preD	= 'd|';
		my @splitC;
		my $indx	= 0;
		$_		= $path;
		if(! /home/) {$path = $basePath . $path;}
		$path =~ s/\/\//\//g;

		$status = fileHandling::fh_readDirectory($path);
		$_ = $status;
		@splitC = split("\n");
		$status = '';
		while($_ = $splitC[$indx++]) {
			if(-d $path . $_) {$status .= $preD . $_ . "\n";}
			if(-f $path . $_) {$status .= $preF . $_ . "\n";}
		}

		$data{result} = $status;
        }



	if($process eq "readServerFile") {

		my $fName	= $q->param('fileName');
		my $basePath	= "/home/akassoc/";
		my $status	= "";
		$_		= $fName;
		if(!/home/) 
			{$fName = $basePath . $_;}
			
		$fName		=~ s/\/\//\//g;

		$status		= fileHandling::readFile($fName);
		$data{result}	= $status;
	}

	if($process eq "readServerFileEncrypt") {

		my $basePath = "/home/akassoc/";
		my $status	= "";
		my $path	= $q->param('fileName');
		if( memberHandling::validateIPLogin()) {
			$_ = $path;
			if(! /home/) {$path = $basePath . $path;}
			$path =~ s/\/\//\//g;

			$status = fileHandling::readFileEncrypt($path);
			$data{result} = $status;
		}
		else {$data{result} = "-1";}
	}




	if($process eq "readMemberFile") {
		
		my $status	= "";
		my $email  	= $q->param('email'); 

		$status = memberHandling::getActvMemberFilePath($email);
		if($status eq "-1") {$status = memberHandling::getInActvMemberFilePath($email);}
                $status = memberHandling::readMemberFile($status);
		$data{result} = $status;
	}


	if($process eq "writeMemberFile") {
		
		my $status	= "";
		my $email  	= $q->param('email'); 
                my $fC          = $q->param('fileContents');

		$status = memberHandling::getActvMemberFilePath($email);
		if($status eq "-1") {
			$status = memberHandling::getInActvMemberFilePath($email);
			if($status eq "-1") {return("-1");}
		}
                $status = memberHandling::writeMemberFile($status, $fC);
		$data{result} = "0";
        }

	if($process eq "writeServerFileEncrypt") {
		
		my $status	= "";
		my $fnm		= $q->param('fileName');
		my $fileName	= '';
                my $fC          = $q->param('fileContents');
		$_		= $fnm;
		if(!/home/) 
			{$fileName  = "/home/akassoc/".$q->param('fileName');}		# added DOCRoot so server can find and create file 1/31/2020 - jpl
		else 
			{$fileName = $fnm;}
		$fileName =~ s/\/\//\//g;
		
                $status = memberHandling::writeMemberFile($fileName, $fC);
		$data{result} = $status;
        }


	if($process eq "updateMemberFieldServerFile") {
		my $fileName	= $q->param('fileName');
		$_		= $fileName;
		if(!/home/) {$fileName = "/home/akassoc/$fileName";}

		my $fieldName	= $q->param('fieldName');
		my $fieldValue	= $q->param('fieldValue');
		my $fC		= memberHandling::readMemberFile($fileName);
		$fC		= memberHandling::updateMemberField($fC, $fieldName, $fieldValue);
				  memberHandling::writeMemberFile($fileName, $fC);
		$data{result}	= "0";
	}

	if($process eq "appendServerFile") {

		my $fName	= $q->param('fileName');
		$_		= $fName;
		if(!/home/) {$fName = "/home/akassoc/$fName";}
		my $status	= "";
		$status = fileHandling::appendFile($fName,  $q->param('appendString'));
		$data{result} = "";
	}

	if($process eq "appendServerLogFile") {
		my $fileName	= $q->param('fileName');
		$_		= $fileName;
		if(!/home/) {$fileName = "/home/akassoc/$fileName";}

		my $status	= "";
		my $oStr	= $q->param('appendString');

		$status = fileHandling::appendFile($fileName, akaRoutines::formatTime() . '     ' ."$ENV{REMOTE_ADDR}   " . $oStr . "\n");
		$data{result} = "";
	}


	if($process eq "writeServerFile") {

		my $fName	= $q->param('fileName');
		my $basePath	= "/home/akassoc/";
		my $status	= "";
		$_		= $fName;
		if(!/home/) 
			{$fName = $basePath . $_;}
			
		$fName		=~ s/\/\//\//g;
		$_		= $q->param('appendString');

		$status = fileHandling::writeFile($fName, $_);
		$data{result} = "0";
	}


	if($process eq "validateEmail") {

		my $email = $q->param('email');

		my $status = akaRoutines::validateEmail($email);

		$data{result} = "0";

		if($status == -1)  {$data{result} = "-1";}
	}


	if($process eq "renameServerFile") {

		my $oldName   = $q->param('fromFile');
		my $newName   = $q->param('toFile');
		my $retStat   = -1;
                $data{result} = '-1';

		$_ = $oldName; if(!/home/) {$oldName = "/home/akassoc/$oldName";}
		$_ = $newName; if(!/home/) {$newName = "/home/akassoc/$newName";}


		if($oldName ne '' && $newName ne '') {
			$retStat = fileHandling::fh_moveFile($oldName, $newName);
			if($retStat == 0) {$data{result} = '0';}			
		}
	}

#
#
# 2021-12-01 - jpl Added code to handle problamatic purges to use back-tick rm approach before giving up
#
#

	if($process eq "purgeServerFile") {
		

		my $oldName	= $q->param('fileName'); $oldName =~ s/\/\//\//g; $oldName =~ s/\s//g;
                my $stat	= 0;
		my $tmp		= $oldName;

		$_ = $oldName; 
		if(!/home/) 
			{$stat = unlink "/home/akassoc/$oldName";}
		else 
			{$stat = unlink $oldName;} 

		if(! $stat) {
			$tmp =~ s/.*\///;
			#fileHandling::appendFile(_globalFileNames::generalLogging(), akaRoutines::formatTime() . "     Error #: $! will try back-tick purge, File could not pe purged: $tmp \n");

			`rm $oldName`;
		}



	}

	if($process eq "loadHTML") {

		my $fC = $q->param('htmlFilename');
		fileHandling::appendFile(_globalFileNames::generalLogging(), akaRoutines::formatTime() . "     loadHTML filename: $fC \n");
		$fC = fileHandling::readFile($fC);
		if($fC eq '-1') 
			{fileHandling::appendFile(_globalFileNames::generalLogging(), akaRoutines::formatTime() . "     loadHTML error reading file: $q->param('htmlFilename')\n");}		
	
		print "Content-Type: text/html\n\n";
		print $fC;

		exit 0;
	}

	if($process eq "moveServerFile") {

		my $oldName = $q->param('fromFile');
		my $newName = $q->param('toFile');
                my $stat = 0;
                my $tmp = '';
		my $cnt = 0;
                $data{result} = '-3';

		#
		# added to handle special case of email files on server for "junk" mial processing
		#
		$_ = $oldName;
		if(/var\/mail/i) {
			`mv $oldName $newName`;
			$data{result} = 0;
			print $q->header('application/json');
			print to_json(\%data);
			exit 0;
		} 

		if($oldName eq '' || $newName eq '' || $oldName eq $newName) {
			$data{result} = '-1';
		}
		else {
			$_ = $oldName; if(!/home/) {$oldName = "/home/akassoc/" . $oldName;}
			$oldName =~ s/\/\//\//g; $oldName =~ s/\s//g;

			$_ = $newName; if(! /home/) {$newName = "/home/akassoc/" . $newName;}
			$newName =~ s/\/\//\//g; $newName =~ s/\s//g;


                        $tmp = fileHandling::readFile($newName); $data{result} = $tmp;
			if($tmp eq "-1") {
				$stat = copy($oldName, $newName);
                                if($stat == 1) {
					$cnt = unlink $oldName; $data{result} = "0"; 
					if($cnt == 0) {$data{result} = '-2';}
				} 
			}
		}
	}


	if($process eq "testEncCode") {

 		my $encCode = $q->param('encKey');
		my $fC = "";
		my @splitC;
		my $indx = 0;

		$data{result} = '-1';

		if(length($encCode) < 12) {
			print $q->header('application/json');
			print to_json(\%data);
			exit 0;
		}

		$fC = fileHandling::readFileEncrypt('/home/akassoc/!logging/~aka/~member/~encKeys.log');

		$_ = $fC;

		@splitC = split("\n");

		for($indx = 0; $indx < @splitC; $indx++) {

			$_ = $splitC[$indx];

			if(/$encCode/) {
				$data{result} = '0';
				print $q->header('application/json');
				print to_json(\%data);
				exit 0;
			} 
		}

	}

	print $q->header('application/json');
	print to_json(\%data);
	exit 0;

