#!/home/akassoc/localperl/bin/perl5.30.0
#
# Library Locations Here
use lib '/home/akassoc/localperl/lib/5.30.0';
use lib '/home/akassoc/localperl/lib/site_perl/5.30.0'; 
use lib '/home/akassoc/cgi-bin/^Library';

use _globalFileNames;

package akaRoutines;

my $loginHistory = _globalFileNames::loginHistory();


#
# loadPage
#
# opens *.html file page and prints all records of the file to the client bowser
#
# only one argument 
#
# useage pageLoad("myPage");
#
#

sub loadPage{

	my $fullPath=$_[0];
	my @contents;
	my $index=0;
	my $uFile="";

	$_=$fullPath;

	m/(^.*\/).*$/;
	my $path=$1;
#	print $path,"<br>\n";
#	print $fullPath,"<br>\n";
#	exit 0;


	if(!open(IFL, $fullPath)) {

#		akaRoutines::logError(1, "loadPage; can't open html page; pagename: ".$fullPath);
		print "can't open file" . $fullPath;

		return(-1);
		
	} else {

		@contents=<IFL>;
		close(IFL);


		while($_=$contents[$index++]) {

			if(m/#include/) {

				if(!m/file="(.*)"/) {
					m/virtual="(.*)"/;
					$uFile=$1;} 
			else {$uFile=$path.$1; }

				open(inFile, $uFile);
				print <inFile>;
				close(inFile);

			} else {print $_;}


		}
	}

	return(0);
}



sub checkLogin {

	my $callFunction	= $_[0];

	my $i = 0;
	my $j = 0;
	my $k = 0;
	my $tHr = 0;
	my $tMn = 0;
	my $found = 0;
	my $curTime = akaRoutines::formatTime();
	$_ = $curTime;
	m/^(\d\d\d\d:\d\d:\d\d):(\d\d):(\d\d):\d\d/;
	my $matchMajor	= $1;
	my $cHr		= $2;
	my $cMn		= $3;
	my $cCt		= ($cHr * 60) + $cMn;
	my $tOt		= 0;
	my $recrd	= '-1';

	my $ipAddr = $ENV{REMOTE_ADDR};

#	print $ipAddr . '  ' . $matchMajor;
	$_ = fileHandling::readFile($loginHistory);
	my @fC = split(/\n/);

	for($i = 0; $i < @fC; $i++) {

		$_ = $fC[$i];
		if(/$ipAddr/) {$recrd = $_;}
	}

	$_ = $recrd;

	if(/logout/i || $recrd eq '-1') {
		fileHandling::appendFile(_globalFileNames::generalLogging() , formatTime() . "     $callFunction; Access failed, $ipAddr\n");
		return(1);
	}

	m/^(\d\d\d\d:\d\d:\d\d):(\d\d):(\d\d):\d\d/;
	$tHr	= $2;
	$tMn	= $3;
	$tOt	= ($tHr * 60) + $tMn;

	if(/^$matchMajor/ && /$ipAddr/  && ($cCt - $tOt) > 360) {
		fileHandling::appendFile(_globalFileNames::generalLogging() , formatTime() . "     $callFunction; Access failed, $ipAddr\n");
		return(1);
	}

	if(/^$matchMajor/ && /$ipAddr/  && ($cCt - $tOt) < 120) {
		fileHandling::appendFile(_globalFileNames::generalLogging() , formatTime() . "     $callFunction; $recrd\n");
		return(0);
	}

	fileHandling::appendFile(_globalFileNames::generalLogging() , formatTime() . "     $callFunction; Access failed, $ipAddr\n");
	return(2);
}


sub loadEncryptHTML{

	my $fullPath=$_[0];
	my $Contents;

#	$Contents = edCryptLibrary::decFile($fullPath);

	print $Contents;

	return(0);
}




sub gobackScript {

	print "<html>\n";
	print "<script>\n";
	print "function goBack()\n";
	print "{\n";
	print "window.history.back()\n";
	print "}\n";
	print "</script>\n";
}

sub pageReturn{

	print "<html>";
	print "<br><H4> If your browser doesn't automatically return to homepage in 5 seconds <a HREF=\"https://aka.org/!area_Affiliates/wako/index.html\"><b><u>return to homepage</b></u></H4></a><br>";
	print "<META HTTP-EQUIV=\"refresh\" CONTENT=\"1; url=https://aka.org/!area_Affiliates/wako/index.html\" >" ;
	exit 0;
}


sub goBack {

	print "<body>";
	print "<h3>", $_[0], "</h3>\n";
	print "<h4>", $_[1], "</h4>\n";
	print "<button onclick=\"goBack()\">Return</button>";
	print "</body>";
	exit 0;
}


#
#
# appendTextFile(Filename, Filepath, OutputString);
#
#
#

sub appendTextFile {

	my $fdest=$_[0];
	my $fname=">>".$_[1].$fdest;

	if (! open(AF, $fname)) {
		akaRoutines::logError(1, 'appendTextFile; error on opening output file; filename: '.$fname);
		return(-1);
	} else {
		print AF $_[0]."\n";
		close(AF);
	}
}

#
# writetextFile(filename, path, testdata);
#
#

sub writetextFile {

	my $filename=">".$_[1].$_[0];

 	if (! open(WRTF, $filename)) {
		akaRoutines::logError(1, 'writetextFile; error opening output file; filename: '.$filename);
		return(-1);

	} else {

		print WRTF $_[2];
		close(WRTF);
		return(0);
	}
}


sub createOptionList {

	my $inFile=$_[0];
	my $outFile=$_[1];
	my $id=$_[2];
	my @inData;
	my $index=0;

	if(!open(inFile, $inFile)) {
		akaRoutines::logError(1, 'createOptionList; could not open input file; filname; '.$inFile);
		return(-1);}

	@inData=<inFile>;
	close(inFile);

	if (!open(outHTML, ">".$outFile)) {
		akaRoutines::logError(1, 'createoptionList; could not open output file; filename: '.$outFile);
		return(-1);}

	print outHTML '<select name="'.$id.'" id="'.$id.'">'."\n";

	print outHTML "<option value=\"", "none", "\">","Select file", "</option>\n";

	while($_ = $inData[$index++]) {
		s/\s+$//;
		print  outHTML "<option value=\"", $_, "\">", $_, "</option>\n";
	} 

	print outHTML '</select>'."\n";

	close(outHTML);

	return(0);
}


sub removeWhiteSpace {
#
	$_=$_[0];
	my $count=1;
	while($count) {
		$count = s/\s+//;
	}
}


#
# fixed for use with decrypt file for users and administration lists
# last modified jpl 2/12/15
#
#
sub createUserList {

	my $inStrng = $_[0];

	my $admList	=  "$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers/~adminList.txt";
	my $memList	=  "$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers/~MembersList.txt";
	my $path	=  "$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers";

	my $idex	= 0;
	my $kdex	= 0;
	my $found	= 0;
	my $fileContent;


	my @dList="";
	my @fList="";
	my @wList="";

	if(!opendir(tDir, $path)) {
		akaRoutines::logError(1, 'createuserList; could not open member directory; directory: '.$path);
		return(-1);}
	
	@dList=readdir tDir;
	closedir(tDir);
 

	while($_ = $dList[$idex++]) {
#		print $_, "<br>\n";

		if(!(m/^~/ || m/^\./ || m/^\.\./)) {
			
#			$fileContent = edCryptLibrary::decFile($path.'/'.$_);
			if($fileContent != -1) {
				@fList=split("\n", $fileContent);
			}

			$found=0;
			$kdex=0;
			while(($_ = $fList[$kdex++]) && !$found) {
				if(m/$inStrng/) {
					$found=1;
					push(@wList, $dList[$idex-1]."\n");
				}
			}
		}

	}

	@wList = sort @wList;
	if($inStrng eq 'Administrator') {	
		open(oFile, ">$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers/~adminList.txt");}
	else {open(oFile, ">$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers/~memberList.txt");}
	print oFile @wList;

	close(oFile);

}


sub createEmailList {

	my $users	= $_[0];

	my $emailList = "";

	my $userFile 	="$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers/~adminList.txt";

	if($users eq 'Members') {
		$userFile="$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers/~memberList.txt";}

	if(!open(userList, $userFile)) {
		print "error opening file from createEmailList, filename=: ", $userFile, "<br>\n";
		akaRoutines::goBack("Re\-enter Filename", "Try Again");
		exit 0;
	}

	while(<userList>) {


		m/^(.*)\|(.*)\|(.*)/;

		$emailList=$emailList.", ".$3;
	}

	$_=$emailList;

	s/^,//;

	closedir(userList);
}


sub goHome{

#	my $q = new CGI;
#	chdir '..';
	akaRoutines::loadPage('../index.html');
#	exit 0;

}



sub updateLastLogin{

	my $first	= $_[0];
	my $last	= $_[1];
	my $email	= $_[2];
	my $time	= $_[3];

	my $fname=">>$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers/~lastLogin.txt";

	open(OFL, $fname);
	print OFL $time, ":", $last, ":", $first, ":", $email, "; IP Address: ", "$ENV{REMOTE_ADDR}", "\n";
	close(OFL);
}



sub writeuserHTMLFile {	

	my $userfilename=$_[0];

	my @userData;
	my @userPrefix;
	my @userHeader;
	my @htmlFile;
	my $j;
	my $k;
	my $n;
	my $find;
	my $sub;

	my $path="$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers/";
	my $filenam=$path . $userfilename;
	my $filename;
#
#
#
# Open registrant datafile
#1	if(!open(ff, $filenam)) {
#1		akaRoutines::logError(1, 'writeuserHTMLFile; could not open user member input file; filname; '.$filenam);
#1		return(-1);
#1	}
#1	@userData=<ff> ;
#1	close(ff);
#	print $filenam,"\n<br>";
#	my $content=edCryptLibrary::decFile($filenam);
	my $content = "";
	if($content == -1) {akaRoutines::logError(1, "writeuserHTMLFile error opening input file:".$filenam."\n");
		RETURN(-1)}
	@userData = split("\n", $content); 

	$n=0;
	while($userData[$n]) {
		$userData[$n].="\n";
		$n++;
	}
	
	@userPrefix = @userData;
	@userHeader = @userData;
	$n=0;
	while($userPrefix[$n]) { 
		$_=$userPrefix[$n];
		s/"# .+\s+/" /;
		$userPrefix[$n]=$_;

		$_=$userData[$n];
		if(m/comments___/) {
			$userPrefix[$n]="comments___";
			s/comments___# //;
		}
		else { s/#//; }	

		$userData[$n]=$_;
		$n++;	
	}
#
#
# Open registrant form field output file
	$path="$ENV{DOCUMENT_ROOT}/~Members/Tmp/";
	$filenam=">" . $path . $userfilename . '.html';

	if (!open(outHTML, $filenam)) {
		akaRoutines::logError(1, 'writeuserHTMLFile; could not open user output file; filename; '.$filenam);
		return(-1);
	}
	
#
#
# Open the html base file
#
	$filename="UserRegEntryForm-II.html" ;  # was my ....
	$path="$ENV{DOCUMENT_ROOT}/~Members/";  # was my ....
	$filenam=$path . $filename;  # was my ....

	if (open(inHTML, $filenam)) {

		my @htmlFile=<inHTML>;
		$j=0;
		while($_=$htmlFile[$j]) {
			my $n=0;
			while ($find=$userPrefix[$n]) {
				$sub=$userData[$n];
				$k=s/$find/$sub/;
				
				if(m/type=\"checkbox/) {
#					print '<br>'.$_.'<br>'."\n";
					m/value\=\"(.*)\"/;
					my $val=$1;
					s/value=\".*\"/$val/;
				}

				$n++;
			}
			print outHTML $_;
			$j++;
		}

#
# print out the stored header block information in a comment area in the temp html file
		print outHTML "<!-- File Header Saved<br>\n";
		$n=0;
		while ($_=$userHeader[$n]) {
			s/\n+//;
			s/\r+//;
			if(m/^#/) {print outHTML $_, "<br>\n";}
			$n++;
		}
		
		print outHTML "-->\n";
#
# done with special write
#
		close(outHTML);
		close(inHTML);
	}

	else {
		akaRoutines::logError(1, 'writeuserHTMLFile; could not open HTML input file; filanme: '. $filenam);
	}
#	print "</html>";

}

sub logError {
	
	my $errlevel 	= $_[0];
	my $message	= $_[1];
	$message=~s/\s+$//;

	my $sec;
	my $min;
	my $hour;	
	my $mday;
	my $mon;
	my $year;
	my $wday;
	my $yday;
	my $isdst;
	my $msgTime;

	($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst)=localtime();

	$year=$year+1900;
	$mon=$mon+1;

	if($mon < 10) { $mon = "0".$mon;}
	if($min < 10) { $min = "0".$min;}
	if($hour < 10) { $hour = "0".$hour;}
	if($mday < 10) { $mday = "0".$mday;}
	if($sec < 10) { $sec = "0".$sec;}

	$msgTime=$year.":".$mon.":".$mday.":".$hour.":".$min.":".$sec;

	open(oFile, ">>$ENV{DOCUMENT_ROOT}/cgi-bin/~Logs/~errorLog.txt");
	print oFile $msgTime.':'.$message."\n";
	close(oFile);
}


sub getMemberInfo {

#
# passed parameters
	my $memberFile 	= $_[0];
	my $memberArray	= $_[1];
	my $AdminMember	= $_[2];
	my $content;

#local parameters

	my @memberData;
	my $index=0;

#	if(!open(inFile, $memberFile)) {
#		logError(1, 'getMemberInfo: file open error; filname: '.$memberFile);
#		return(-1)}	

#	$content = edCryptLibrary::decFile($memberFile);
	@memberData = split("\n", $content);

#	@memberData=<inFile>;
#	close(inFile);

	my $PVTemail	=akaRoutines::getField('emailPVT',	\@memberData);
	my $PVTaddr	=akaRoutines::getField('addressPVT',	\@memberData);
	my $PVTphone	=akaRoutines::getField('phonePVT',	\@memberData);

	if(($PVTemail eq 'unchecked') || $AdminMember) {
		my $email	= akaRoutines::getField('1.email',	\@memberData);
		@$memberArray[$index++] = 'Email: '.$email."\n";
		@$memberArray[$index++] = "\n";}

	if(($PVTphone eq 'unchecked') || $AdminMember) {
		my $areacode	= akaRoutines::getField('pp.areacode',	\@memberData);
		my $prenum	= akaRoutines::getField('pp.prenum',	\@memberData);
		my $postnum	= akaRoutines::getField('pp.postnum',	\@memberData);
		@$memberArray[$index++] = 'Phone: ('.$areacode.') '.$prenum.'-'.$postnum."\n";
		@$memberArray[$index++] = "\n";
	}

	if(($PVTaddr eq 'unchecked') || $AdminMember) {
		my $addr1	= akaRoutines::getField('1.address',	\@memberData);
		my $addr2	= akaRoutines::getField('2.address',	\@memberData);
		my $addr3	= akaRoutines::getField('3.address',	\@memberData);
		my $city	= akaRoutines::getField('city',		\@memberData);
		my $state	= akaRoutines::getField('state',		\@memberData);
		my $zipcode	= akaRoutines::getField('zipcode',	\@memberData);
		my $azipcode	= akaRoutines::getField('azipcode',	\@memberData);
		my $country	= akaRoutines::getField('country',	\@memberData);

		@$memberArray[$index++] = $addr1."\n";
		if($addr2 ne ""){ @$memberArray[$index++] = $addr2."\n";}
		if($addr3 ne ""){ @$memberArray[$index++] = $addr3."\n";}
		if($azipcode eq "") {@$memberArray[$index++]=$city.", ".$state."  ".$zipcode.', '.$country."\n";}
		if($azipcode ne "") {@$memberArray[$index++]=$city.", ".$state."  ".$zipcode.'-'.$azipcode.', '.$country."\n";}
	}

	$index=0;

	return(0);
	
}


sub getField {

	my $fieldName	= $_[0];
	my $fieldArray	= $_[1];
	my $fieldString	='';

	my $index=0;
	while($_=@$fieldArray[$index++]) {
		if(m/$fieldName/) {
			$fieldString=$_;
			$fieldString=~m/^.*(\".*\").*(\".*\")/;
			$fieldString=$2;
			$fieldString=~s/\"//g;
			return($fieldString);
		}
	}
 
	$fieldString="";
	return($fieldString);
}

#
# updated findMemberRecord to search for exact name match
#

sub findMemberRecord{

	my $searchFor = $_[0];
#	print $searchFor, "SearchFor from find member record<br>\n"; 
	my $fname = "$ENV{DOCUMENT_ROOT}/~Members/ActiveMembers/~memberList.txt";
	my @Buffer;
	my @splits;
	my $first;
	my $last;
	my $index=0;

	if(!open(inFile, $fname)) {
		logError(1, "findMemberRecord: file open error; ".$fname);
		return("");}

	@Buffer = <inFile>;
	close(inFile);

	$_=$searchFor;

	m/(.*) (.*)/;

	$last = lc($2);  $last =~ s/\W+//g;
	$first = lc($1); $first =~ s/\W+//g;

	while($_=lc($Buffer[$index++])) {

		@splits = split(/\|/);

		if(($splits[0] eq $last) && ($splits[1] eq $first)) {
			$searchFor=$_;
			return($searchFor);
		}
	}

	return("");
}

sub randomChar {

	my $abcString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

	my $rNumber = int (rand(52));

	my $rChr = substr($abcString, $rNumber, 1);

	return($rChr);
}

sub mntxt2Numeric {

	my $mn = $_[0];

	my $idx = 0;

	my @mntxt = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"); 
	
	while($_ = $mntxt[$idx++]) {
		if(/$mn/i) {
			if($idx < 10) {$idx = "0" . $idx;}
			return($idx);
		}
	}

	return("-1");

}


sub formatTime {

	my $sec;
	my $min;
	my $hour;	
	my $mday;
	my $mon;
	my $year;
	my $wday;
	my $yday;
	my $isdst;
	my $msgTime;

	$tm = time() + 3600; # add one hour from server

	($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst)=localtime($tm);

	$year=$year+1900;
	$mon=$mon+1;

	if($mon < 10) { $mon = "0".$mon;}
	if($min < 10) { $min = "0".$min;}
	if($hour < 10) { $hour = "0".$hour;}
	if($mday < 10) { $mday = "0".$mday;}
	if($sec < 10) { $sec = "0".$sec;}

	$msgTime=$year.":".$mon.":".$mday.":".$hour.":".$min.":".$sec;
	
	return($msgTime);
}



sub isleapyear {

	my $yr = $_[0];
	my $t1	= 0;
	my $t2	= 0;
	my $t3	= 0;

	$t1 = $yr % 4;
	$t2 = $yr % 100;
	$t3 = $yr % 400;

	if($t1 == 0 &&(( $t2 != 0) || ($t3 == 0))) {return(1);}
	return(0);
}


sub diffDate {

	my $srtDate = $_[0];
	my $endDate = $_[1];

	my $indx = 0;


	$_	= $srtDate;

	m/(\d\d\d\d):(\d\d):(\d\d)/;

	my $yr1 = $1;
	my $mn1	= $2;
	my $dy1	= $3;

	$_	= $endDate;

	m/(\d\d\d\d):(\d\d):(\d\d)/;

	my $yr2 = $1;
	my $mn2	= $2;
	my $dy2	= $3;

	my $dyy1 = 0;
	my $dyy2 = 0;

#
# we calculate our offset from the base of the first year
#
	my @numDays1 = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	my @numDays2 = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);


	if(isleapyear($yr1)) {$numDays1[1] = 29;}
	if(isleapyear($yr2)) {$numDays2[1] = 29;}

	for($indx = 0; $indx < ($mn1 - 1); $indx++) {$dyy1 += $numDays1[$indx];}
	$dyy1 += $dy1;  # number of days in first date

	for($indx = 0; $indx < ($mn2 - 1); $indx++) {$dyy2 += $numDays2[$indx];}
	$dyy2 += $dy2;  # number of days in first date
	if($yr1 != $yr2) {for($indx = 0; $indx < 12; $indx++) {$dyy2 += $numDays1[$indx];}}

	return($dyy2 - $dyy1);

}





sub updateEmailList {


	my $name = $_[0];
	my $outFile = ">> $ENV{DOCUMENT_ROOT}/~Dynamic-Content/~eBNL/eBNLLog";

	open(oFile, $outFile);
		print oFile akaRoutines::formatTime() . ",  " . $name . "\n";
	close(oFile);
	return(0);

}



sub updateNoticeList {


	my $name = $_[0];
	my $outFile = ">> $ENV{DOCUMENT_ROOT}/cgi-bin/~AdminTools/customDB/workingFiles/tmpNoticeList";

	open(oFile, $outFile);
		print oFile akaRoutines::formatTime() . ",  " . $name . "\n";
	close(oFile);
	return(0);

}



sub updateexceptionNoticeList {


	my $name = $_[0];
	my $outFile = ">> $ENV{DOCUMENT_ROOT}/cgi-bin/~AdminTools/customDB/workingFiles/tmpexceptionNoticeList";

	open(oFile, $outFile);
		print oFile akaRoutines::formatTime() . ",  " . $name . "\n";
	close(oFile);
	return(0);

}


sub substituteMsgFields {

	my $body	= $_[0];
	my @fields	= split($_[1], "\n");

	my $str1 = "";
	my $str2 = "";
	my $indx = 0;

	while($_ = $fields[$indx++]) {
		m/(.*)\|(.*)/;
		$str1 = $1; $str2 = $2; 
		$str1 =~ s/\s//g; $str2 =~ s/\s//g;	# get our field name and substitution 
		$body =~ s/$str1/$str2/i;			# perfrom our substitutions 
	}

	return($body);
}



1;

