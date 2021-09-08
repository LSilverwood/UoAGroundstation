#!/bin/bash

mkdir "Wavs"

#Loop through each .ogg
for filename in *.ogg; do
#Taking advantage of the consistent filename format to extract the observation number
	echo "$filename"
    	obsnumber=$(echo "$filename" | awk -F_ '{ print $2 }' )
    	echo "$obsnumber"
    	#Retrieving the webpage for that observation
    	url='https://network.satnogs.org/observations/'
    	wget "${url}$obsnumber" -O satpage.html
    	
    	#Matching the correct data tag to find the NORAD ID
    	NORAD=$(grep -F "SatelliteModal" satpage.html | grep -F "data-id" | grep 'data-id=\".*\"' -o | grep -o '[[:digit:]]*')
    	
    	echo "$NORAD"
    	
	#Creating a handy file name
	datetime=$(echo "$filename" | awk -F_ '{ print $3 }' | awk -F. '{ print $1 }' )
	prefix="./Wavs/NoradID_"
	sep="_"
	ext=".wav"
	newname="${prefix}$NORAD${sep}$obsnumber${sep}$datetime${ext}"
	
	#Converting the file
	ffmpeg -i "$filename" -r 48e3 "$newname"
	
	
    
done

