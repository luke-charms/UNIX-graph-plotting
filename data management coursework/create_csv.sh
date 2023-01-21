#!/bin/bash
#Bash script to sort through hurricane data presented in a kml type file and filter out the important components to then store in a csv file.

grep 'UTC\|N,\|mb\|knots' $1 | #search through the input file for the keywords:"UTC", "N,", "mb" & "knots".
sed 's/<[^>]*>//g' | #removes all characters in between any two tags (<*>).
sed 's/\;.*$//g' | #remove all other unnecessary data which comes after all ';' in the file.
sed 's/[ \t]*//' | #format data correctly by removing all tabs from shell output
uniq | #deletes all duplicate lines
awk '!(NR%5==1)' | #removes every 5th line from shell output, as these lines contained additional unncessary duplicate data 
awk '0!=NR%4{$0=$0","} 1' | #add a comma to every line except the 4th ones
sed ':a;/,$/{N;s/\n//;ba}' | #merge all relevant data in one cycle of hurricane into a single line by merging lines together that end in a comma
sed -e 's/ -/-/g' -e 's/ ,/,/g' | #remove whitespace behind negative signs & commas
sed '1 i\Timestamp,Latitude,Longitude,MinSeaLevelPressure,MaxIntensity' > $2 #add relevant text to first line of shell output and pipe into output path file
