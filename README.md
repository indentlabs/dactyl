[![Build Status](https://travis-ci.org/indentlabs/dactyl.svg)](https://travis-ci.org/indentlabs/dactyl)

Linguistic fingerprinting as a service

/api/v1/dactyl?text=Hello,%20world! will return a JSON hash of linguistic analytics

/api/v1/dactyl?text=Hello,%20world!How%20are%20you???hi&metrics[]=verbs will allow you to specify which metrics you are interested in computing/receiving (_all_ by default)

Design guidelines @ https://www.muicss.com/docs/v1/css-js/boilerplate-html


Files supported are:

		Plain Text           (txt)
		Rich Text Format     (rtf)
		Portable Data Format (pdf)
		Microsoft Word       (docx)

The text is extracted without formatting.  Basic error checking and sanitizing of input is accomplished to prevent injection attacks.  
However, neither extensive testing nor fuzzing has been accomplished.
