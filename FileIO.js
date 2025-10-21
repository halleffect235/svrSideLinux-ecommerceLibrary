//
//     <script type='text/javascript' src='https://aka.org/!area_Support/cgi-jScripts/~libraryJScripts/aJax.js'></script>
//
//
//
//
// intenal function to determine if our server calls are http or https
//    not intended to be used from main libraries or general scripts
//
     function getSrvrProtocol() {

        if(location.protocol == 'https:') {return true;}
        return false;

     }


     function loadHTMLServerFile(htmlFilename) {
                var fC = '-1';
                var url = 'aka.org/cgi-bin/^javaSupport/fileIO.pl';
               
                if(getSrvrProtocol()) {url = 'https://' + url;} else {url = 'http://' + url;}

		$.ajax({
				type :   'POST',
                                async:   true,
				url  :   url,
				data : { 'process'       : 'loadHTML',
                                         'htmlFilename'  : htmlFilename,}
                        });
					
//			}).done(function(msg) {fC = msg.result;});

//              return fC;
     }

     function createServerDirectory(dirPath) { 

                var fC = '-1';
                var url = 'aka.org/cgi-bin/^javaSupport/fileIO.pl';
               
                if(getSrvrProtocol()) {url = 'https://' + url;} else {url = 'http://' + url;}

		$.ajax({
				type :   'POST',
                                async:   false,
				url  :   url,
				data : { 'process'        : 'createServerDirectory',
                                         'dirPath'        : dirPath,}
					
			}).done(function(msg) {fC = msg.result;});

              return fC;

     }


//
//
// readserverFile
//
// read a file on the remote server via aJax, note this is used for ssl encryption
//
//  08/06/2017 - jpl created and developed
//
//  08/26/2017 - jpl added synchronous call, we'll see if this works better
//
// fileName - string, file path below "public_html", server will build rest of the file path
//
//
     function readServerFile(fileName) {

              var fC    = '-1';
              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';

              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:   false,
                                url  :   url,
                                data : { 'process'        : 'readServerFile',
                                         'fileName'       : fileName,}
					
                    }).done(function(msg) {fC = msg.result;});

              return fC;

     }


//
//
// readserverFileEncrypt
//
// read a file on the remote server via aJax, note this is used for ssl encryption
//
//  08/06/2017 - jpl created and developed
//
//  08/26/2017 - jpl added synchronous call, we'll see if this works better
//
// fileName - string, file path below "public_html", server will build rest of the file path
//
//
     function readServerFileEncrypt(fileName) {

              var fC    = '-1';
              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';

              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:   false,
                                url  :   url,
                                data : { 'process'        : 'readServerFileEncrypt',
                                         'fileName'       : fileName,}
					
                    }).done(function(msg) {fC = msg.result;});

              return fC;

     }


     function readServerDirectory(dirPath) { 

                var fC = '-1';
                var url = 'aka.org/cgi-bin/^javaSupport/fileIO.pl';

                if(getSrvrProtocol()) {url = 'https://' + url;} else {url = 'http://' + url;}

		$.ajax({
				type :   'POST',
                                async:   false,
				url  :   url,
				data : { 'process'        : 'readServerDirectory',
                                         'dirPath'        : dirPath,}
					
			}).done(function(msg) {fC = msg.result;});

              return fC;

     }


     function readServerDirectoryDetails(dirPath) { 

                var fC = '-1';
                var url = 'aka.org/cgi-bin/^javaSupport/fileIO.pl';

                if(getSrvrProtocol()) {url = 'https://' + url;} else {url = 'http://' + url;}

		$.ajax({
				type :   'POST',
                                async:   false,
				url  :   url,
				data : { 'process'        : 'readServerDirectoryDetails',
                                         'dirPath'        : dirPath,}
					
			}).done(function(msg) {fC = msg.result;});

              return fC;

     }


     function renameServerFile(start, end) {

                var fC = '-1';
                var url = 'aka.org/cgi-bin/^javaSupport/fileIO.pl';

                if(getSrvrProtocol()) {url = 'https://' + url;} else {url = 'http://' + url;}

                $.ajax({
                                type :   'POST',
                                async:   false,
                                url  :   url,
                                data : { 'process'        : 'renameServerFile',
                                         'fromFile'       : start,
                                         'toFile'         : end,}
					
                        }).done(function(msg) {fC = msg.result;});

              return fC;
     }


     function moveServerFile(start, end) { 

                var fC = '-1';
                var url = 'aka.org/cgi-bin/^javaSupport/fileIO.pl';

                if(getSrvrProtocol()) {url = 'https://' + url;} else {url = 'http://' + url;}

                $.ajax({
                                type :   'POST',
                                async:   false,
                                url  :   url,
                                data : { 'process'        : 'moveServerFile',
                                         'fromFile'       : start,
                                         'toFile'         : end,}
					
                        }).done(function(msg) {fC = msg.result;});

              return fC;
     }


     function appendServerLogFile(fileName, dString) { 

              var fC    = '-1';
              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';

              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:    false,
				url  :    url,
				data : { 'process'        : 'appendServerLogFile',
                                         'fileName'       : fileName,
                                         'appendString'   : dString,
                                   }
					
                     }).done(function(msg) {fC = msg.result;});

              return fC;
     }


     function appendServerFile(fileName, dString) { 

              var fC    = '-1';
              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';

              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:    false,
				url  :    url,
				data : { 'process'        : 'appendServerFile',
                                         'fileName'       : fileName,
                                         'appendString'   : dString,
                                   }
					
                     }).done(function(msg) {fC = msg.result;});

              return fC;
     }


     function writeServerFile(fileName, dString) { 

              var fC    = '-1';
              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';

              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:    false,
				url  :    url,
				data : { 'process'        : 'writeServerFile',
                                         'fileName'       : fileName,
                                         'appendString'   : dString,
                                   }
					
                     }).done(function(msg) {fC = msg.result;});

              return fC;
     }


     function readServerMemberFile(email) { 

              var fC    = '-1';
              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';

              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:    false,
				url  :    url,
				data : { 'process'     : 'readMemberFile',
                                         'email'       : email,
                                       }
					
                     }).done(function(msg) {fC = msg.result;});

              return fC;
     }


     function writeServerFileEncrypt(fileName, fC) {

              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';

              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:    false,
				url  :    url,
				data : { 'process'     : 'writeServerFileEncrypt',
                                         'fileName'    : fileName,
                                         'fileContents': fC,
                                       }
					
                     }).done(function(msg) {fC = msg.result;});

              return fC;
     }


//
//
// updateMemberFieldServerFile
//
// read a file on the remote server, update a specific data field in file, via aJax, note this is used for ssl encryption
//
//  04/10/2021 - jpl created and developed
//
//  04/10/2021 - jpl added synchronous call, we'll see if this works better
//
// fileName - string, file path below "public_html", server will build rest of the file path
//
//
     function updateMemberFieldServerFile(fileName, fieldName, fieldValue) { //alert(fileName + ' ' + fieldName + ' ' + fieldValue);

              var fC    = '-1';
              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl'; 


              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:   false,
                                url  :   url,
                                data : { 'process'        : 'updateMemberFieldServerFile',
                                         'fileName'       : fileName,
                                         'fieldName'      : fieldName,
                                         'fieldValue'     : fieldValue,}
					
                    }).done(function(msg) {fC = msg.result;});

              return fC;

     }


     function writeServerMemberFile(email, fC) { 

              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';

              var https = getSrvrProtocol();

              if(https) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:    false,
				url  :    url,
				data : { 'process'     : 'writeMemberFile',
                                         'email'       : email,
                                         'fileContents': fC,
                                       }
					
                     }).done(function(msg) {fC = msg.result;});

              return fC;
     }


     function purgeServerFile(fileName) { //alert('from purge ajax call: ' + fileName);

              var fC    = '-1';
              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';


              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:   false,
                                url  :   url,
                                data : { 'process'        : 'purgeServerFile',
                                         'fileName'       : fileName,}
					
                    }).done(function(msg) {fC = msg.result;});

              return fC;

     }




//
//
// testEncCode
//
// read a file on the remote server via aJax, note this is used for ssl encryption
//
//  08/06/2017 - jpl created and developed
//
//  08/26/2017 - jpl added synchronous call, we'll see if this works better
//
// fileName - string, file path below "public_html", server will build rest of the file path
//
//
     function testEncCode(encKey) {

              var fC    = '-1';
              var url   = '://aka.org/cgi-bin/^javaSupport/fileIO.pl';

              if(getSrvrProtocol()) {url = 'https' + url;} else {url = 'http' + url;}

              $.ajax({
                                type :   'POST',
                                async:   false,
                                url  :   url,
                                data : { 'process'	: 'testEncCode',
                                         'encKey'       : encKey,}
					
                    }).done(function(msg) {fC = msg.result;});

              return fC;

     }
















