#!/bin/bash

function unpack() #To determine the compressed file type and use the appropriate uncompress tool
{
	if [ -f $filename ] ;
	then
		case "$filename" in
			*.7z)		7z x $filename	  	;; 
			*.bz2)		bunzip2 $filename 	;;
			*.gz)		gunzip $filename  	;;
			*.rar)		unrar x $filename 	;;
			*.tar)		tar xvf $filename 	;;
			*.tar.bz2)	tar xvjf $filename	;;
			*.tar.gz)	tar xvzf $filename	;;
			*.tbz2)		tar xvjf $filename	;;
			*.tgz)		tar xvzf $filename	;;
			*.Z)		uncompress $filename	;;
			*.zip)		unzip $filename		;;
			*)		echo "'$filename' something went wrong when unpacking" ;;
		esac
	else
		printf -- '-%.0s' {1..100}; echo ""
		echo "'$filename' is not a valid file"
		exit 1
	fi
}	

function remove() #To remove the original file or keep it
{
	printf -- '-%.0s' {1..100}; echo ""
	echo "Do you want to remove the original file? ($filename)"
	read -p "Y or N: " yn 
	case "$yn" in
		[yY])
			printf -- '-%.0s' {1..100}; echo ""
			echo "Removing $filename"
			rm $filename ;;
		[nN])
			printf -- '-%.0s' {1..100}; echo ""
			echo "$filename will not be removed" ;;
		*)
			printf -- '-%.0s' {1..100}; echo ""
			echo "Something went wrong and the file was not removed" ;;
	esac
}

function extractfolder() #To move the extracted file to a new folder
{
	printf -- '-%.0s' {1..100}; echo ""
	echo "Would you like to move the extracted file to a new directory?"
	read -p "Y or N: " ynf
	case "$ynf" in
		[yY])
			printf -- '-%.0s' {1..100}; echo ""
			echo "Please enter a name for the new directory."
			read newdirect
			if [ -d $newdirect ] #Check if the directory exists 
			then
				find $PWD -maxdepth 1 -cnewer unpacker.sh -not -name "*.sh" -type f -exec mv "{}" $newdirect \;
				printf -- '-%.0s' {1..100}; echo ""
				echo -e "Directory ($newdirect) already exists\nMoving Now."
			else
				mkdir $newdirect
				find $PWD -maxdepth 1 -cnewer unpacker.sh -not -name "*.sh" -type f -exec mv "{}" $newdirect \;
				printf -- '-%.0s' {1..100}; echo ""
				echo "Moving Extract to new directory: $newdirect" 
			fi ;;
		[nN])
			printf -- '-%.0s' {1..100}; echo ""
			echo "Extracting in current directory" 
			pwd ;;
		*)
			printf -- '-%.0s' {1..100}; echo ""
			echo "Something went wrong and the file was not moved" ;;
	esac
}

ls -al
echo "Please enter the compressed file to unpack"
read -p "Compressed File Name: " filename

unpack
if [ $? != 0 ] ; #Can be changed just if unpack to be safer about return code
then 
	printf -- '-%.0s' {1..100}; echo ""
	echo "Something went wrong with the extraction"
	exit 1
else
	printf -- '-%.0s' {1..100}; echo ""
	echo "Extraction completed"
	extractfolder
	remove
fi
