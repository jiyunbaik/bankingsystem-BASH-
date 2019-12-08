#!/bin/bash
source ./functions.sh

for (( ; ; ))
do
 	startMenu
	if [ $start -eq 1 ]
	then
		login
	elif [ $start -eq 2 ]
	then
		addNewProfile
		addNewInfo
		addNewUser
		login
	elif [ $start -eq 3 ]
	then
		exit
	else
		errorMsg
	fi
	makeReceipt
	for (( ; ; ))
	do
		mainMenu
		if [ $main -eq 1 ]
		then
			deposit
		elif [ $main -eq 2 ]
		then
			withdraw
		elif [ $main -eq 3 ]
		then
			viewAccountBalance
		elif [ $main -eq 4 ]
		then
			showReceipt
			exit
		else
			errorMsg
		fi
	done
done
