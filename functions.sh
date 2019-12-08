#!/bin/bash
login(){
	local match=0
	while [[ match -ne 2 ]]; do
		echo ===LOG IN===
		echo Please enter your username
		read username
		echo Please enter your password
		read password		
		echo $username:$password > ./Profile/userLoginTemp.txt
		cat ./Profile/userlogin.txt | tr -s ':' | cut -d ':' -f2-3 >> ./Profile/userLoginTemp.txt
		grep $username:$password ./Profile/userLoginTemp.txt > ./Profile/userLoginTemp2.txt
		match=$(sort ./Profile/userLoginTemp2.txt | uniq -c | tr -s ' ' | cut -d ' ' -f2)
		rm -f ./Profile/userLoginTemp2.txt
		rm -f ./Profile/userLoginTemp.txt
		if [ $match -ne 2 ]
		then
			echo You have entered wrong username or password
			echo Please try again
		fi
	done
	echo You are logged in successfully
	accountNumber=$(cat ./Profile/userlogin.txt | grep "$username:$password" | tr -s ':' | cut -d ':' -f1)
	accountProfile=$(cat ./Profile/userprofiles.txt | grep "$accountNumber")
	accountInfo=$(cat ./Accounts/accountInformation.txt | grep "$accountNumber")
	accountUser=$(cat ./Profile/userlogin.txt | grep "$accountNumber")
	balance=$(echo $accountInfo | tr -s ':' | cut -d ':' -f3)
	info=$(echo $accountInfo | tr -s ':' | cut -d ':' -f1-2)
	startingBalance=$balance
}

addNewProfile(){
	echo ===NEW PROFILE===
	echo Enter your first name
	read firstName
	echo Enter your last name
	read lastName
	echo Enter your address
	read address
	echo Enter your date of birth MM/DD/YYYY
	read dob
	accountNumber=ID$(wc -l ./Profile/userprofiles.txt | tr -s ' ' | cut -d ' ' -f1)
	echo $accountNumber:$firstName:$lastName:$address:$dob >> ./Profile/userprofiles.txt

}

addNewInfo(){
	echo ===ACCOUNT INFORMATION===
	echo Please choose your account type - Chequing/Saving 
	read accountType
	echo Please enter the amount you like to deposit
	read amount
	echo $accountNumber:$accountType:$amount >>./Accounts/accountInformation.txt
}

addNewUser(){
	usernameMatch=0
	echo ===NEW USER===
	while [[ usernameMatch -ne 1 ]]; do
		echo Please enter username you wish to use
		read username
		echo $username > ./Profile/checkUserNameTemp.txt
		cat ./Profile/userlogin.txt | tr -s ':' | cut -d ':' -f2 >> ./Profile/checkUserNameTemp.txt
		grep $username ./Profile/checkUserNameTemp.txt > ./Profile/checkUserNameTemp2.txt
		usernameMatch=$(sort ./Profile/checkUserNameTemp2.txt | uniq -c | tr -s ' ' | cut -d ' ' -f2)
		rm -f ./Profile/checkUserNameTemp.txt
		rm -f ./Profile/checkUserNameTemp2.txt
		if [ $usernameMatch -ne 1 ]
		then
			echo $username already being used
			echo Please try using different username
		fi
	done
	echo Please enter password
	read password	
	echo $accountNumber:$username:$password >>./Profile/userlogin.txt
	echo Your account has been successfully created
}

startMenu(){
	echo ===BANKING SYSTEM===
	echo Choose one of the following option
	echo 1. Log in
	echo 2. New user
	echo 3. Exit
	read start
}

mainMenu(){
	echo ===MAIN MENU===
	echo What would you like to do
	echo 1. Deposit
	echo 2. Withdraw
	echo 3. View account balance
	echo 4. Exit
	read main
}

withdraw(){
	local serviceFee=5
	echo ===WITHDRAW===
	echo How much would you like to withdraw
	echo You will be charged $serviceFee dollars for service
	read withdrawAmount
	local totalWithdrawAmount=`expr $serviceFee + $withdrawAmount`
	if [ $balance -lt $totalWithdrawAmount ]
	then
		echo Insufficient Account balance
	else
		local newBalance=`expr $balance - $totalWithdrawAmount`
		echo withdraw $withdrawAmount >> ./receipt.txt
		echo service charge $serviceFee >> ./receipt.txt
		sed -i "s/$info:$balance/$info:$newBalance/" ./Accounts/accountInformation.txt
		echo $accountNumber Balance: $balance Withdraw: $withdrawAmount Service Charge: $serviceFee New Balance: $newBalance >> ./Accounts/transactions.txt
		balance=$newBalance
	fi
	
}

deposit(){
	echo ===DEPOSIT===
	echo How much would you like to deposit
	read depositAmount
	local newBalance=`expr $balance + $depositAmount`
	echo deposit $depositAmount >> ./receipt.txt
	sed -i "s/$info:$balance/$info:$newBalance/" ./Accounts/accountInformation.txt
	echo $accountNumber Balance: $balance Deposit: $depositAmount New Balance: $newBalance >> ./Accounts/transactions.txt
	balance=$newBalance
}

viewAccountBalance(){
	echo ===ACCOUNT BALANCE===
	echo Account $info
	echo Your current balance in account is $balance
}

showReceipt(){
	cat ./receipt.txt
	echo Final balance: $balance
	rm ./receipt.txt
}

makeReceipt(){
	echo ===RECEIPT=== > ./receipt.txt
	echo Account $info >> ./receipt.txt
	echo Starting balance: $startingBalance >> ./receipt.txt
}

errorMsg(){
	echo ERROR: Invalid Input Option 1>&2
}
