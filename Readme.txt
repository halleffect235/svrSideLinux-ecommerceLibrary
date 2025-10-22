
  JP Langan
  13186 15th Street S.
  Afton, MN 55001

  dev-softw@dyn-eng.com

  Questions are always answered...
  I hope you find usefuless in my code




There are mutiple parts to this library

	linux Web server for feeding html
		perl code to be located on webserver, usually Apache but doesn't need to be
		server to be configured with perl version 5 or later
		generally perl code and it's libraries are to be loaded on a drectory under the 
			website's directory html structure "cgi-bin" or other name according to the 
			Apache rules setup for the host website's services
			
		Website's html code must reference a configured directory which contains the javascript libraries
			These libraries file end in ".js", these files are the executable javascript code to be embedded in the
			website's html sources.
			
		aJAx this is a google api interface written in javascript which data exchanges with the perl sources located on the 
			isp host web-based server.
			
			
			
	Process page.html 	-> aJax call to retrieve file data from server -> (Apache or other configured server) cgi-bin/executasblefile.pl 
	
				-> code on host server executes retrieves file data, returns file data to the aJax call waiting for results
				-> javascript based program in the html receives data and data is available to the javascript based program 
				   for general use and access
