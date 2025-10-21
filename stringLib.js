//
//
// String Routines used by various modules
//
// variable defs sr_abbrv_ddd
//
// Jun 20, 2016 - jpl
//	Created from file extract
//
// Oct 25, 2020 - jpl added routine sr_AddrValidateField to parse errors in address lines
//
// Apr  7, 2021 - jpl found bug in sr_validateNumericField, did not have \\ string termination, added tested, works
//
//

        function sr_validateNumericField(inString) {

              var chars = "0123456789-.\\";

              return sr_validateString(inString, chars);
        }


	function sr_validateGeneralField(inString) {

		var chars = "abcdefghijklmnopqrstuvwxyz0123456789-_', ;:()=+! .[]{}\\";

		return sr_validateString(inString, chars); 
	}

	function sr_validateAddrField(inString) {

		var chars = "abcdefghijklmnopqrstuvwxyz0123456789-_#.', .\\";

		return  sr_validateString(inString, chars);
	}


	function sr_validateNameField(inString) {

		var chars = "abcdefghijklmnopqrstuvwxyz0123456789-_', .\\";

		return  sr_validateString(inString, chars);
	}


	function sr_validateString(inString, compString) { 

		var tString = inString.toLowerCase();
//
//
		var tSplit = compString.split("");
//
// get inString length
//
		var sLength = 0;
		var indx = 0;
		var idx = 0;
		var tchar = " ";
		var found = false;
//
		sLength = inString.length;
//
		idx = 0;
//
		while(idx < sLength) {

			tchar = tString.substr(idx, 1);

			found = false;

			indx = 0;

			while( (tSplit[indx] != '\\' )  && (! found) ) { 

				if( tchar == tSplit[indx] ){                                
					found = true; 
				}
                                //if( tchar.charCodeAt(0) == 233) {found = true;}

 				indx++;
			}

			if(! found) {return -1;}

			idx++;
		}
//
		return 0;
	}

// 
// remove white space and line feeds
//
       function sr_removeWhiteSpace(inString) {

             inString = inString.replace(/\n/g, "");
             inString = inString.replace(/\s/g, "");

             return inString;


       }


       function randomChar() {

	    var abcString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

            var rNumber = Math.random() * 52.0; 
            if(rNumber < 0) {rNumber = 0;} 
            if(rNumber > 51) {rNumber = 51;}
            //return 'z';
	    return abcString[Math.floor(rNumber)];
       }

       function randomString(nChars) {

            var rStr = '';
            var i    = 0;

            for(i = 0; i < nChars; i++) {rStr += randomChar();}
            return rStr;
       }







