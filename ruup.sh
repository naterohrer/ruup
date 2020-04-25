#!/bin/bash

#Inspired by TomNomNom's tool httprobe: https://github.com/tomnomnom/httprobe
#customization:
#	modify the --connect-timeout to extend the timeout on connection attempts
#	add additional ports to the array ports[] to scan more


echo "                       ___  
                      |__ \ 
 _ __ _   _ _   _ _ __   ) |
| '__| | | | | | | '_ \ / / 
| |  | |_| | |_| | |_) |_|  
|_|   \__,_|\__,_| .__/(_)  
                 | |        
   R u up?       |_|
=========R0@r==============
Check what protocol the webserver is running
===========================
"

#basic array for checking http and https 
proto=( 'http://' 'https://' )
ports=( 4443 8000 8080 8443 10443 )
	if [ "$1" == '-h' ] || [ -z "$1" ]; then
		echo "Usage syantax: ./ruup.sh [domain] or [option]"
		echo "Options:"
		echo "-f [filename] : provide a list of domains  (seperated by new line)"
		echo "-p : run through common alternate ports"
	elif [ "$1" == '-f' ]; then
		if [[ -e $2 ]]; then
		while read domain; do
	        	url=$domain
        		for i in "${proto[@]}"; do
                		#all we care about is status 200 responses
                		if [[ $(curl --connect-timeout 2.37 -H 'Connection: close' $i${url} -I -s | head -n 1 | cut '-d ' '-f2') == 200 ]]; then
                        		echo "$i$url";
                		fi
				# if the -p argument is supplied loop through common http/https ports
				if [ "$2" == '-p' ] || [ "$3" == '-p' ]; then
					for j in "${ports[@]}"; do
						if [[ $(curl --connect-timeout 2.37 -H 'Connection: close' $i${url}:$j -I -s | head -n 1 | cut '-d ' '-f2') == 200 ]]; then
							echo "$i$url:$j";
						fi
					done
				fi
        		done
		done < $2 
		else # -f was supplied but the file doesnt exist
			echo "No file name supplied or the file does not exist!"
		fi
	else
        url=$1      
        for i in "${proto[@]}"; do
                #all we care about is status 200 responses
                if [[ $(curl --connect-timeout 2.37 -H 'Connection: close' $i${url} -I -s | head -n 1 | cut '-d ' '-f2') == 200 ]]; then
                        echo "$i$url";
                fi
		#if the -p argument is supplied loop through common http/https ports
		if [ "$2" == '-p' ] || [ "$3" == '-p' ]; then
			for j in "${ports[@]}"; do
				if [[ $(curl --connect-timeout 2.37 -H 'Connection: close' $i${url}:$j -I -s | head -n 1 | cut '-d ' '-f2') == 200 ]]; then
					echo "$i$url:$j";
				fi
			done
		fi
        done
	fi